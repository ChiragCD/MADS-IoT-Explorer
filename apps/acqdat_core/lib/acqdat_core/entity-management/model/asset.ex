defmodule AcqdatCore.Model.EntityManagement.Asset do
  import AsNestedSet.Modifiable
  import Ecto.Query
  alias AcqdatCore.Model.EntityManagement.Sensor, as: SensorModel
  alias AcqdatCore.Schema.EntityManagement.Asset
  alias Ecto.Multi
  alias AcqdatCore.Repo

  def child_assets(project_id) do
    project_assets = fetch_root_assets(project_id)

    Enum.reduce(project_assets, [], fn asset, acc ->
      entities = AsNestedSet.descendants(asset) |> AsNestedSet.execute(Repo)

      asset = fetch_child_sensors(nil, entities, asset)

      res_asset = fetch_child_sensors(List.first(entities), entities, asset)
      acc ++ [res_asset]
    end)
  end

  def get(id) when is_integer(id) do
    case Repo.get(Asset, id) |> Repo.preload([:org, :project]) do
      nil ->
        {:error, "not found"}

      asset ->
        {:ok, asset}
    end
  end

  @doc """
  Updates an Asset with the provided params.

  **Updating asset position**
  Updating the asset position(root or under another asset) is done by using the
  `parent_id` key. If the `parent_id` is set to `nil` the asset(with it's
  descendants) will be  moved to the root. In case the asset is to be moved
  under another asset then the target asset `id` should be provided under the
  `parent_id` key.

  All the detail and position updates are run under a transaction using
  `Ecto.Multi`. In case if there is any error while updating all the changes
  are reverted.
  """
  @spec update_asset(Asset.t(), map) ::
          {:ok, Asset.t()}
          | {:error, Ecto.Changeset.t()}
  def update_asset(asset, %{parent_id: nil} = params) do
    params = Map.drop(params, [:parent_id])

    Multi.new()
    |> Multi.run(:update_position, fn _, _changes ->
      result =
        asset
        |> AsNestedSet.move(:root)
        |> AsNestedSet.execute(Repo)

      {:ok, result}
    end)
    |> Multi.run(:update_details, fn _, %{update_position: asset} ->
      update_asset(asset, params)
    end)
    |> run_under_transaction(:update_details)
  end

  def update_asset(asset, %{parent_id: parent_id} = params) when not is_nil(parent_id) do
    {:ok, parent_asset} = get(parent_id)
    params = Map.drop(params, [:parent_id])

    Multi.new()
    |> Multi.run(:update_position, fn _, _changes ->
      result =
        asset
        |> AsNestedSet.move(parent_asset, :child)
        |> AsNestedSet.execute(Repo)

      {:ok, result}
    end)
    |> Multi.run(:update_details, fn _, %{update_position: asset} ->
      update_asset(asset, params)
    end)
    |> run_under_transaction(:update_details)
  end

  def update_asset(asset, params) when params == %{}, do: {:ok, asset}

  def update_asset(asset, params) do
    changeset = Asset.update_changeset(asset, params)
    Repo.update(changeset)
  end

  def delete(asset) do
    AsNestedSet.delete(asset) |> AsNestedSet.execute(Repo)
  end

  def add_as_root(%{name: name, org_id: org_id, org_name: org_name, project_id: project_id}) do
    # NOTE: function Ecto.Changeset.__as_nested_set_column_name__/1 is undefined or private
    try do
      taxon =
        asset_struct(%{name: name, org_id: org_id, slug: org_name <> name, project_id: project_id})
        |> create(:root)
        |> AsNestedSet.execute(Repo)

      {:ok, taxon}
    rescue
      error in Ecto.InvalidChangesetError ->
        {:error, error.changeset}
    end
  end

  def add_as_child(parent, name, org_id, position) do
    try do
      child =
        asset_struct(%{
          name: name,
          org_id: org_id,
          slug: parent.org.name <> parent.name <> name,
          project_id: parent.project.id
        })

      taxon =
        child
        |> create(parent, position)
        |> AsNestedSet.execute(Repo)

      {:ok, taxon}
    rescue
      error in Ecto.InvalidChangesetError ->
        {:error, error.changeset}
    end
  end

  def asset_descendants(asset) do
    entities = asset |> AsNestedSet.descendants() |> AsNestedSet.execute(Repo)
    fetch_child_sensors(List.first(entities), entities, asset)
  end

  ############################# private functions ###########################

  defp fetch_root_assets(project_id) do
    query =
      from(asset in Asset,
        where: asset.project_id == ^project_id and is_nil(asset.parent_id) == true
      )

    Repo.all(query)
  end

  defp fetch_child_sensors(_data, entities, asset) do
    entities_with_sensors =
      Enum.reduce(entities, [], fn asset, acc_sensor ->
        entities = SensorModel.child_sensors(asset)
        asset = Map.put_new(asset, :sensors, entities)
        acc_sensor ++ [asset]
      end)

    Map.put_new(asset, :assets, entities_with_sensors)
  end

  defp fetch_child_sensors(nil, _entities, asset) do
    sensors = SensorModel.child_sensors(asset)
    Map.put_new(asset, :sensors, sensors)
  end

  defp asset_struct(%{name: name, org_id: org_id, slug: slug, project_id: project_id}) do
    %Asset{
      name: name,
      org_id: org_id,
      project_id: project_id,
      inserted_at: DateTime.truncate(DateTime.utc_now(), :second),
      updated_at: DateTime.truncate(DateTime.utc_now(), :second),
      uuid: UUID.uuid1(:hex),
      slug: Slugger.slugify(slug),
      properties: []
    }
    |> Repo.preload(:org)
    |> Repo.preload(:project)
  end

  defp run_under_transaction(multi, result_key) do
    multi
    |> Repo.transaction()
    |> case do
      {:ok, result} ->
        {:ok, result[result_key]}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end
end

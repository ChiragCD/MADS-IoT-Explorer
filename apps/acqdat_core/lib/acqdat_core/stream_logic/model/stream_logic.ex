defmodule AcqdatCore.StreamLogic.Model do
  import Ecto.Query
  alias AcqdatCore.Repo
  alias AcqdatCore.StreamLogic.Schema.Workflow
  @doc """
  Creates a workflow and returns it.

  The function also registers a workflow while creating it. Only the registered
  workflows are executed.
  """
  def create(params) do
    changeset = Workflow.changeset(%Workflow{}, params)
    #add code for registering the workflow
    Repo.insert(changeset)
  end

  @doc """
  Updates a workflow with the `params`.

  ## Note
  In case the workflow digraph or the name is updated it will be re-registered.
  """
  def update(workflow, params) do
    changeset = Workflow.update_changeset(workflow, params)
    # add code for updating the registered workflow
    Repo.update(changeset)
  end

  def get(id)  when is_integer(id) do
    case Repo.get(Workflow, id) do
      nil ->
        {:error, "not found"}
      workflow ->
        {:ok, workflow}
    end
  end

  def get(map)  when is_map(map) do
    case Repo.get_by(Workflow, map) do
      nil ->
        {:error, "not found"}
      workflow ->
        {:ok, workflow}
    end
  end

  def get_all(%{
        page_size: page_size,
        page_number: page_number,
        org_id: org_id,
        project_id: project_id
      }) do
    query =
      from(workflow in Workflow,
        where: workflow.org_id == ^org_id and workflow.project_id == ^project_id,
        order_by: workflow.id
      )

    query |> Repo.paginate(page: page_number, page_size: page_size)
  end

  def delete(workflow) do
    try do
      Repo.delete(workflow)
    rescue
      Ecto.StaleEntryError ->
        {:error, "not found"}
      _ ->
        {:error, "Unexpected error"}
    end
  end

  ################## private functions #########################
end

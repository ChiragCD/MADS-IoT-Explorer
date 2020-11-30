defmodule AcqdatCore.StreamLogic.Schema.Workflow do
  @moduledoc """
  Models a workflow in the stream logic.

  A workflow is combination of stream logic nodes which process the incoming
  message block depending on the logic created by the connection.
  """

  use AcqdatCore.Schema
  alias AcqdatCore.Schema.EntityManagement.{Project, Organisation}

  @type t :: %__MODULE__{}

  schema("acqdat_sl_workflow") do
    field(:name, :string, null: false)
    field(:digraph, :map, null: false)
    field(:uuid, :string, null: false)
    field(:enabled, :boolean, default: true)
    field(:metadata, :map, default: %{})

    #associations
    belongs_to(:project, Project)
    belongs_to(:org, Organisation)

    timestamps(type: :utc_datetime)
  end

  @required ~w(name digraph project_id org_id)a
  @optional ~w(enabled metadata)a

  @permitted @required ++ @optional

  def changeset(%__MODULE__{} = workflow, params) do
    workflow
    |> cast(params, @permitted)
    |> add_uuid()
    |> validate_required(@required)
    |> assoc_constraint(:project)
    |> assoc_constraint(:org)
    |> unique_constraint(:name,
      name: :unique_flow_name_per_project,
      message: "workflow with this name exists"
    )
  end

  def update_changeset(%__MODULE__{}=workflow, params) do
    workflow
    |> cast(params, @permitted)
    |> validate_required(@required)
    |> assoc_constraint(:project)
    |> assoc_constraint(:org)
    |> unique_constraint(:name,
      name: :unique_flow_name_per_project,
      message: "workflow with this name exists"
    )
  end

end

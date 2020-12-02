defmodule AcqdatApiWeb.StreamLogic.WorkflowController do
  use AcqdatApiWeb, :controller
  import AcqdatApiWeb.Validators.StreamLogic.Workflow
  import AcqdatApiWeb.Helpers
  alias AcqdatApi.StreamLogic
  plug AcqdatApiWeb.Plug.LoadStreamLogicWorkflow when action in [:update, :delete]

  def index(conn, params) do
    changeset = verify_index_params(params)
    with {:extract, {:ok, params}} <- {:extract, extract_changeset_data(changeset)} do
      workflows = StreamLogic.get_all(params)
      conn
      |> put_status(200)
      |> render("index.json", %{workflows: workflows})
    else
      {:extract, {:error, errors}} ->
        send_error(conn, 400, errors)
    end
  end

  def create(conn, params) do

  end

  def update(conn, params) do

  end

  def show(conn, params) do

  end

  def delete(conn, params) do

  end

end

defmodule AcqdatApiWeb.StreamLogic.WorkflowControllerTest do
  use ExUnit.Case, async: true
  use AcqdatApiWeb.ConnCase
  use AcqdatCore.DataCase
  import AcqdatCore.Support.Factory
  alias AcqdatApiWeb.StreamLogic.WorkflowController

  describe "index/1 " do
    setup :setup_conn
    setup do
      project = insert(:project)
      [project: project]
    end

    test "returns a list of workflows", context do
      %{project: project, conn: conn} = context
      org = project.org
      digraph = create_digraph()
      entries = 6
      insert_list(entries, :workflow, project: project, org: org, digraph: digraph)

      params = %{
        page_size: 2,
        page_number: 1
      }
      conn = get(conn, Routes.workflow_path(conn, :index, org.id, project.id), params)
      result = conn |> json_response(200)
      assert result["page_size"] == params.page_size
      assert result["page_number"] == params.page_number
      assert result["total_entries"] == entries
    end

    test "returns error for bad request", %{conn: conn} do
      params = %{
        page_size: 2,
        page_number: 1
      }

      result = WorkflowController.index(conn, params) |> json_response(400)
      assert %{
        "errors" => %{
          "message" => %{
            "org_id" => ["can't be blank"],
            "project_id" => ["can't be blank"]
          }
        }
      } == result
    end
  end

  describe "create/2 " do

  end
end

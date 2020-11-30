defmodule AcqdatCore.StreamLogic.Model.StreamLogicTest do
  use ExUnit.Case, async: true
  use AcqdatCore.DataCase
  alias AcqdatCore.StreamLogic.Model.StreamLogic
  import AcqdatCore.Support.Factory

  describe "create/1" do
    setup do
      project = insert(:project)
      [project: project]
    end

    test "create and register a workflow", %{project: project} do

    end
  end
end

defmodule AcqdatCore.Factory.Workflow do
  defmacro __using__(_options) do
    alias AcqdatCore.StreamLogic.Schema.Workflow

    quote do
      def workflow_factory() do
        %Workflow{
          name: sequence(:sl_workflow_name, &"workflow#{&1}"),
          digraph: %{},
          project: build(:project),
          org: build(:project),
          uuid: UUID.uuid1(:hex),
          enabled: true,
          metadata: %{}
        }
      end
    end
  end
end

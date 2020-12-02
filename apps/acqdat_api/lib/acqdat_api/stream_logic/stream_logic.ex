defmodule AcqdatApi.StreamLogic do
  alias  AcqdatCore.StreamLogic.Model, as: StreamLogic

  defdelegate create(params), to: StreamLogic
  defdelegate update(workflow, params), to: StreamLogic
  defdelegate get(params), to: StreamLogic
  defdelegate get_all(params), to: StreamLogic
  defdelegate delete(workflow), to: StreamLogic
end

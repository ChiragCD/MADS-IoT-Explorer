defmodule AcqdataCore.StreamLogic.Functions.ActionNodes.EntityTelemetryAttributes do
  @inports [:input]
  @outports [:success, :failure]
  @properties %{
    entity: "",
    entity_param: ""
    all_similar_type_allow: true
  }
  @category :filter
  @display_name "Entity Telemetry"
  @info """
  Adds telemetry from an entity in the metadata. The entity and it's parameter
  can be selected. If no selection is done then originator and all it's telemetry
  parameters are added to the metadata portion of the message.

  In case entity telemetry data is not found the message is sent on the failure
  path. Also, of the `all_similar_type_allow`
  """

  use Virta.Component

  @impl true
  def run(request_id, inport_args, _outport_args, _instance_pid, properties) do
    params = Map.get(inport_args, :input)
    {request_id, :reply, params}
  end
end

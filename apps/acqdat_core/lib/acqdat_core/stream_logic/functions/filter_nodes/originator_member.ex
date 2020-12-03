defmodule AcqdatCore.StreamLogic.Functions.FilterNode.OriginatorMember do
  @inports [:input]
  @outports [:true, :false]
  @properties [
    originator_types: %{
      type: "select",
      source: ~w(Gateway Sensor Asset Project AssetType SensorType)s
    },
    members: %{
      type: "select",
      source: ""
    }
  ]
  @category :filter
  @display_name "Originator Member Filter"
  @info """
  The node checks if the incoming message originator id is present in the configuration
  set for the node. A originator can be of the following types:
  - `Gateway`
  - `Sensor`
  - `Asset`
  - `Project`

  The metadata field of the message contains the originator type and the originator
  id fields. These fields are used for the evaluation. In case the originator
  id is found in configuration set, the message is sent via the true path, else
  the false path is used.
  """

  use Virta.Component

  @impl true
  def run(request_id, inport_args, _outport_args, _instance_pid, properties) do
    params = Map.get(inport_args, :input)
    {request_id, :reply, params}
  end
end

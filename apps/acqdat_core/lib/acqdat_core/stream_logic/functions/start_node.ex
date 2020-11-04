defmodule AcqdatCore.StreamLogic.Functions.StartNode do
  @moduledoc """
  Node which starts a logic chain.
  """

  @inports [:std_in]
  @outports [:std_out]
  @properties %{}
  @category :common
  @display_name "Input"
  @info """
  Node starts the logic Chain.
  """

  use Virta.Component

  @impl true
  def run(request_id, inport_args, _outport_args, _instance_pid, _configuration) do
    {request_id, :reply, inport_args}
  end
end

defmodule AcqdatCore.StreamLogic.Functions.StartNode do
  @moduledoc """
  Node which starts a logic chain.
  """

  @inports []
  @outports [:std_out]
  @properties %{}
  @category "Common"
  @display_name "Input"

  use Virta.Component

  @impl True
  def run(request_id, inport_args, _outport_args, _instance_pid, configuration) do

  end
end

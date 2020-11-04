defmodule AcqdatCore.StreamLogic.Functions.FilterNode.Script do
  @moduledoc """
  Evaluates the defined script for the incoming message and channels it across the
  true or false path.

  __Note__ The script should return a `true` or `false` value.
  """
  @inports [:input]
  @outports [:true, :false]
  @properties %{
    script: "return msg.temperature > 20"
  }
  @category :filter
  @display_name "Script"
  @info """
  Evaluates the defined script for the incoming message and channels it across
  the true or false path.

  The incoming data has the following structure.
  {messsag_type: '', message_payload: '', metadata: ''}

  A key inside the message_payload can be accessed to run comparisons
  e.g. message_payload.value > 10.
  Similarly, a key inside the metadata can be accesses as metadata.value and
  comparisons can be done.
  __Note__ The script should return a `true` or `false` value.
  """

  use Virta.Component

  @impl True
  def run(request_id, inport_args, _outport_args, _instance_pid, configuration) do

  end

  def execute_js_function(script, arguments) do

  end


end

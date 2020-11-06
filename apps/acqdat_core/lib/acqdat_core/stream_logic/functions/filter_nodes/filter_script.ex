defmodule AcqdatCore.StreamLogic.Functions.FilterNode.Script do
  @moduledoc """
  Evaluates the defined script for the incoming message and channels it across the
  true or false path.

  __Note__ The script should return a `true` or `false` value.
  """
  @inports [:input]
  @outports [:true, :false]
  @properties %{
    script: "return message_payload.temperature > 20"
  }
  @category :filter
  @display_name "Script"
  @info """
  Evaluates the defined script for the incoming message and channels it across
  the true or false path.

  The incoming data has the following structure.
  {message_type: '', message_payload: '', metadata: ''}

  A key inside the message_payload can be accessed to run comparisons
  e.g. message_payload.value > 10.
  Similarly, a key inside the metadata can be accesses as metadata.value and
  comparisons can be done.
  __Note__ The script should return a `true` or `false` value.
  """

  use Virta.Component

  @impl true
  def run(request_id, inport_args, _outport_args, _instance_pid, properties) do
    params = Map.get(inport_args, :input)
    result = execute_js_function(properties.script, params)
    require IEx
    IEx.pry
    {request_id, :reply, result}
  end

  def execute_js_function(script, params) do

  end

end

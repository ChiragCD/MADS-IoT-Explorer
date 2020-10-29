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
  @category "Filter"
  @display_name "Script"

  use Virta.Component

  @impl True
  def run(request_id, inport_args, _outport_args, _instance_pid, configuration) do

  end

  defp execute_js_function(script, arguments) do

  end
end

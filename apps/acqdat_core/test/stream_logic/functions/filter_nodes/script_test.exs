defmodule AcqdatCore.StreamLogic.Functions.FilterNode.ScriptTest do
  use ExUnit.Case, async: true
  alias AcqdatCore.StreamLogic.Token
  alias AcqdatCore.StreamLogic.Functions.StartNode
  alias AcqdatCore.StreamLogic.Functions.FilterNode.Script

  alias Virta.Node
  alias Virta.Registry
  alias Virta.EdgeData

  describe "suceess path: " do
    setup do
      payload = %{hum: 20, temp: 30}
      type = :raw_telemetry
      metadata = %{device_id: 1234}
      data = [message_type: type, message_payload: payload, metadata: metadata]
      {:ok, token} = Token.new(data)
      [token: token]
    end

    test "if script returns true data sent on path", %{token: token} do
      node1 = %Node{module: StartNode, id: 0}
      js_script = "return message_payload.hum > 20;"
      config = %{}
      node2 = %Node{module: Script, id: 1, configuration: js_script}
      graph =
        Graph.new(type: :directed)
        |> Graph.add_edge(
          node1,
          node2,
          label: %EdgeData{from: :std_out, to: :input}
        )

        name = "script_test"

        data = %{
          node1 => [{1, :std_in, token}]
        }

      {:ok, "registered"} = Registry.register(name, graph)
      {request_id, output} = Virta.Executor.call(name, data)
    end
  end

end

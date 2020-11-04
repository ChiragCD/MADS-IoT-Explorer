defmodule AcqdatCore.StreamLogic.Functions.FilterNode.ScriptTest do
  use ExUnit.Case, async: true
  alias AcqdatCore.StreamLogic.Token
  alias AcqdatCore.StreamLogic.Functions.StartNode
  alias AcqdatCore.StreamLogic.Functions.FilterNode.Script


  describe "suceess path: " do
    setup do
      payload = %{hum: 20, temp: 30}
      type = :raw_telemetry
      metadata = %{device_id: 1234}
      data = [message_type: type, message_payload: payload, metadata: metadata]
      token = Token.new(data)
      [token: token]
    end

    test "if script returns true data sent on path", %{token: token} do
      node1 = %{module: StartNode, id: 0}
      config = %{}
      node2 = %{module: Script, id: 0, comfiguration: js_script}
      graph =
        Graph.new(type: :directed)
        |> Graph.add_edge(

        )
    end
  end

end

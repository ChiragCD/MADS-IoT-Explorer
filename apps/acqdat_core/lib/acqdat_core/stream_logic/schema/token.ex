defmodule AcqdatCore.StreamLogic.Token do
  @moduledoc """
  Models a message token passing through differnt nodes inside a workflow.

  The token provides a structure to the message passing through different nodes.
  """
  @data_types ~w(
    structured_telemetry
    raw_telemtry
  )a

  @enforce_keys [:message_type, :message_payload, :metadata]
  defstruct ~w(
    message_type
    message_payload
    metadata
  )a

  @typedoc """
  * `:message_type`: The type of message can be one of the following type.
          - `structured_telemetry`
          - `raw_telemetry`
  * `:message_payload`: the telemetry payload
  * `:metadata`: extra information about the message.
  """
  @type t :: %__MODULE__{
    message_type: String.t(),
    message_payload: map,
    metadata: map
  }

  def new(opts) when opts == %{} do
    {:error, "expect data and data_type"}
  end

  def new(opts) do
    if valid_data_type?(opts.data_type) do
      {:ok, struct(%__MODULE__{
        message_type: "",
        message_payload: %{},
        metadata: %{}
      }, opts)}
    else
      {:error, "invalid data type"}
    end
  end

  def valid_data_type?(data_type) do
    Enum.member?(@data_types, data_type)
  end
end

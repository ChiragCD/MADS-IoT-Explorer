defmodule AcqdatCore.StreamLogic.Token do
  @moduledoc """
  Models a message token passing through differnt nodes inside a workflow.

  The token provides a structure to the message passing through different nodes.
  """
  @data_types ~w(
    strcutured_telemetry
    unstructured_telemtry
  )a

  defstruct ~w(
    message_type
    message_payload
    metadata
  )a

  def new(opts) when opts == %{} do
    {:error, "expect data and data_type"}
  end

  def new(opts) do
    if valid_data_type?(opts.data_type) do
      {:ok, struct(%__MODULE__{}, opts)}
    else
      {:error, "invalid data type"}
    end
  end

  def valid_data_type?(data_type) do
    Enum.member?(@data_types, data_type)
  end
end

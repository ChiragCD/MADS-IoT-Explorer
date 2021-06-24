defmodule AcqdatApi.Alerts.AlertFilterListing do
  @moduledoc """
  All the helper functions related to alert rules listing.
  """
  def list_status() do
    Enum.reduce(AlertStatusEnum.__enum_map__(), [], fn {key, _value}, acc ->
      acc ++ [key]
    end)
  end

  def list_app() do
    Enum.reduce(AppEnum.__enum_map__(), [], fn {key, _value}, acc ->
      acc ++ [key]
    end)
  end
end

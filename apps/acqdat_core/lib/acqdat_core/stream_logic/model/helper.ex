defmodule AcqdatCore.StreamLogic.Model.Helpers do
  @moduledoc """
  Helper methods for streamlogic.
  """

  @doc """
  Returns a list of all the function nodes in streamlogic.

  Every element of the list containes a detailed information about the
  function node.
  """
  @spec components() :: [map]
  def components() do
    list = StreamLogicFunctionEnum.__enum_map__()

    list
    |> Stream.map(fn {key, value} ->
      key
    end)
    |> Enum.map(fn module ->
      add_module_details(module)
    end)
  end

  # Creates a map containing all the module information for a function node.
  # Function nodes are defined in the function folder. Nodes are of different
  # types such as action, filter or enrichment.
  defp add_module_details(module) do
    module_details = module.component_properties()
    module = to_string(module)
    Map.put(module_details, :module, module)
  end
end

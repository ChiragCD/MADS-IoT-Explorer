defmodule AcqdatCore.Ntools.Kafka do
  alias KafkaEx.Protocol.CreateTopics.TopicRequest

  defmodule Topic  do
    @enforce_keys ~w(topic_name num_partitions replication_factor)a

    defstruct ~w(topic_name num_partitions replication_factor)a
    @type t :: %__MODULE__{
      topic_name: binary(),
      num_partitions: integer(),
      replication_factor: integer()
    }
  end

  @moduledoc  """
  Exposes functions for interacting with kafka.
  """

  @doc """
  Creates topics in advance for kafka.

  Expects a list of `Topic.t()` structs.

  The map should have following mandatory keys
  `topic_name`, `num_partitions` and `replication factor`
  """
  def create_topics(topics) do
    list = create_topics_request(topics)
    KafkaEx.create_topics(list)
  end

  defp create_topics_request(topics) do
    Enum.map(topics, fn topic ->
      %TopicRequest{
        topic: topic.topic_name,
        num_partitions: topic.num_partitions,
        replication_factor: topic.replication_factor
      }
    end)
  end
end

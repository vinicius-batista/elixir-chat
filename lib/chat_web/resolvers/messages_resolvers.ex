defmodule ChatWeb.Resolvers.MessagesResolvers do
  alias Chat.Rooms

  def create_message(_, %{input: input}, %{context: %{current_user: current_user}}) do
    attrs =
      input
      |> Map.put(:user_id, current_user.id)

    Rooms.create_message(attrs)
  end

  def message_added(%{room_id: room_id}, %{context: context}) do
    if Map.has_key?(context, :current_user) do
      {:ok, topic: room_id}
    else
      {:ok, topic: 0}
    end
  end

  def get_messages(_, %{room_id: room_id, cursor: cursor, limit: limit}, _) do
    messages = Rooms.list_messages(room_id, limit, cursor)
    {:ok, messages}
  end
end

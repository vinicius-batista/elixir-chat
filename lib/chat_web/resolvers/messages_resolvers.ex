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
end

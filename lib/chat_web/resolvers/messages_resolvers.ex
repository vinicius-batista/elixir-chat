defmodule ChatWeb.Resolvers.MessagesResolvers do
  alias Chat.Rooms

  def create_message(_, %{input: input}, %{context: %{current_user: current_user}}) do
    attrs =
      input
      |> Map.put(:user_id, current_user.id)

    Rooms.create_message(attrs)
  end
end

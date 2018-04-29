defmodule ChatWeb.Resolvers.RoomsResolvers do
  alias Chat.Rooms

  def create_room(_, %{input: input}, %{context: %{current_user: current_user}}) do
    attrs =
      input
      |> Map.put(:owner_id, current_user.id)

    Rooms.create_room(attrs)
  end

  def update_room(_, %{input: input}, %{context: %{current_user: current_user}}) do
    case Rooms.get_room_by(id: input.id, owner_id: current_user.id) do
      nil -> {:error, "Room not found"}
      room -> Rooms.update_room(room, input)
    end
  end
end

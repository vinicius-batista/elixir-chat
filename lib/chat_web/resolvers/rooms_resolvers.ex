defmodule ChatWeb.Resolvers.RoomsResolvers do
  @moduledoc """
  Graphql Rooms's resolvers
  """
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

  def delete_room(_, %{id: id}, %{context: %{current_user: current_user}}) do
    room_params = [id: id, owner_id: current_user.id]

    with room when is_map(room) <- Rooms.get_room_by(room_params),
         {:ok, _} <- Rooms.delete_room(room) do
      {:ok, "Room deleted successfully."}
    else
      _ -> {:error, "Room not found"}
    end
  end

  def get_rooms(_, %{name: name, cursor: cursor, limit: limit}, _) do
    rooms = Rooms.list_rooms(name, limit, cursor)
    {:ok, rooms}
  end

  def get_room(_, %{id: id}, _) do
    case Rooms.get_room(id) do
      nil -> {:error, :not_found}
      room -> {:ok, room}
    end
  end
end

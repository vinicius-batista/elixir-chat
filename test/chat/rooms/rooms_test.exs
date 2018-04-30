defmodule Chat.RoomsTest do
  use Chat.DataCase

  alias Chat.Rooms
  alias Chat.Accounts

  describe "rooms" do
    alias Chat.Rooms.Room

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}
    @user_attrs %{
      name: "some name",
      email: "email@email.com",
      password: "test",
      username: "username"
    }

    def user_fixture() do
      {:ok, user} = Accounts.create_user(@user_attrs)
      user
    end

    def room_fixture(attrs \\ %{}) do
      user = user_fixture()

      {:ok, room} =
        attrs
        |> Enum.into(%{owner_id: user.id})
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/3 returns all rooms with query" do
      room = room_fixture()
      assert Rooms.list_rooms("some") == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "get_room_by/1 returns the room with given id and owner_id" do
      room = room_fixture()
      assert Rooms.get_room_by(id: room.id, owner_id: room.owner_id) == room
    end

    test "create_room/1 with valid data creates a room" do
      user = user_fixture()

      attrs =
        @valid_attrs
        |> Enum.into(%{owner_id: user.id})

      assert {:ok, %Room{} = room} = Rooms.create_room(attrs)
      assert room.description == "some description"
      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = Rooms.update_room(room, @update_attrs)
      assert %Room{} = room
      assert room.description == "some updated description"
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end

  describe "messages" do
    alias Chat.Rooms.Message

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def message_fixture(attrs \\ %{}) do
      room = room_fixture(%{description: "some description", name: "some name"})

      {:ok, message} =
        attrs
        |> Enum.into(%{room_id: room.id, user_id: room.owner_id})
        |> Enum.into(@valid_attrs)
        |> Rooms.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Rooms.list_messages(message.room_id) == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Rooms.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      room = room_fixture(%{description: "some description", name: "some name"})

      attrs =
        %{room_id: room.id, user_id: room.owner_id}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Message{} = message} = Rooms.create_message(attrs)
      assert message.text == "some text"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Rooms.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.text == "some updated text"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_message(message, @invalid_attrs)
      assert message == Rooms.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Rooms.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Rooms.change_message(message)
    end
  end
end

defmodule ChatWeb.MessagesResolverTest do
  use ChatWeb.ConnCase

  alias Chat.{Accounts, Rooms}

  @user_valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test",
    username: "username"
  }

  setup do
    {:ok, user} = Accounts.create_user(@user_valid_attrs)

    room_attrs = %{
      name: "room name",
      description: "room description",
      owner_id: user.id
    }

    {:ok, room} = Rooms.create_room(room_attrs)

    message_attrs = %{
      text: "test --",
      room_id: room.id,
      user_id: user.id
    }

    {:ok, message} = Rooms.create_message(message_attrs)
    {:ok, %{user: %Accounts.User{user | password: nil}, room: room, message: message}}
  end

  test "create_message returns new message", %{conn: conn, user: user, room: room} do
    query = "
      mutation($input:CreateMessageInput!) {
        createMessage(input:$input) {
          id,
          text,
          user {
            id
          }
        }
      }
    "
    text = "some message text"

    variables = %{
      input: %{
        text: text,
        room_id: room.id
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("createMessage")

    assert response["text"] == text
    assert response["user"]["id"] == to_string(user.id)
  end

  test "messages returns list of message", %{conn: conn, user: user, room: room} do
    query = "
      query($room_id: Int!){
        messages(room_id: $room_id) {
          id,
          text,
          user {
            id,
            name
          }
        }
      }
    "

    variables = %{
      room_id: room.id
    }

    [message] =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("messages")

    assert message["text"] == "test --"
    assert message["user"]["id"] == to_string(user.id)
    assert message["user"]["name"] == user.name
  end
end

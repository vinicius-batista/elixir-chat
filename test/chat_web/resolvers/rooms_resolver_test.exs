defmodule ChatWeb.RoomsResolverTest do
  use ChatWeb.ConnCase

  alias Chat.{Accounts, Rooms}

  @user_valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test",
    username: "username"
  }

  @update_query "
    mutation ($input:UpdateRoomInput!) {
      updateRoom(input:$input) {
        id,
        name,
        description
      }
    }
  "

  setup do
    {:ok, user} = Accounts.create_user(@user_valid_attrs)

    room_attrs = %{
      name: "room name",
      description: "room description",
      owner_id: user.id
    }

    {:ok, room} = Rooms.create_room(room_attrs)

    {:ok, %{user: %Accounts.User{user | password: nil}, room: room}}
  end

  test "create_room returns room object", %{conn: conn, user: user} do
    query = "
      mutation ($input:CreateRoomInput!) {
        createRoom(input:$input) {
          id,
          name,
          description
        }
      }
    "

    variables = %{
      input: %{
        name: "nice room name",
        description: "nice room description"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("createRoom")

    assert response["name"] == "nice room name"
    assert response["description"] == "nice room description"
  end

  test "update_room returns room object", %{conn: conn, user: user, room: room} do
    variables = %{
      input: %{
        id: room.id,
        name: "updated room name",
        description: "updated room description"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: @update_query, variables: variables)
      |> get_query_data("updateRoom")

    assert response["name"] == "updated room name"
    assert response["description"] == "updated room description"
  end

  test "update_room returns error", %{conn: conn, user: user} do
    variables = %{
      input: %{
        id: 0,
        name: "updated room name",
        description: "updated room description"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: @update_query, variables: variables)
      |> get_query_data("updateRoom")

    assert response == nil
  end
end

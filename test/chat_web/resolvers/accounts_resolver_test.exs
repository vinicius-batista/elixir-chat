defmodule ChatWeb.AccountsResolverTest do
  @moduledoc """
  Accounts resolver tests
  """
  use ChatWeb.ConnCase
  alias Chat.{Accounts, Rooms}

  @valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test",
    username: "username"
  }

  setup do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, token} = Accounts.create_token(%{user_id: user.id})

    room_attrs = %{
      name: "room name",
      description: "room description",
      owner_id: user.id
    }

    {:ok, _room} = Rooms.create_room(room_attrs)

    {:ok, %{user: %Accounts.User{user | password: nil}, token: token}}
  end

  test "register_user returns string for success", %{conn: conn} do
    query = "
    mutation ($input: RegisterUserInput!) {
        registerUser(input: $input)
      }
    "

    variables = %{
      input: %{
        name: "test name",
        email: "test-email@email.com",
        password: "test-password",
        username: "some-username"
      }
    }

    response =
      conn
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("registerUser")

    assert response == "User registred successfully."
  end

  test "login_user return auth tokens", %{conn: conn} do
    query = "
      mutation ($input:LoginUserInput!) {
        loginUser(input: $input) {
          type,
          refreshToken,
          accessToken
        }
      }
    "

    variables = %{
      input: %{
        email: "email@email.com",
        password: "test"
      }
    }

    response =
      conn
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("loginUser")

    assert response["type"] == "bearer"
    assert is_bitstring(response["accessToken"])
    assert is_bitstring(response["refreshToken"])
  end

  test "new_access_token return new auth tokens", %{conn: conn, user: user, token: token} do
    query = "
      query ($refreshToken:String!) {
        newAccessToken(refreshToken:$refreshToken) {
          type,
          accessToken,
          refreshToken
        }
      }
    "

    variables = %{
      "refreshToken" => token.refresh_token
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("newAccessToken")

    assert response["type"] == "bearer"
    assert is_bitstring(response["accessToken"])
    assert response["refreshToken"] == token.refresh_token
  end

  test "profile return user info", %{conn: conn, user: user} do
    query = "
      query {
        profile {
          id,
          name,
          insertedAt,
          username
        }
      }
    "

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query)
      |> get_query_data("profile")

    assert response["id"] == to_string(user.id)
    assert response["name"] == user.name
    assert response["username"] == user.username
  end

  test "profile return user info with room", %{conn: conn, user: user} do
    query = "
      query {
        profile {
          id,
          name,
          insertedAt,
          username,
          rooms {
            name,
            description,
            id
          }
        }
      }
    "

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query)
      |> get_query_data("profile")

    [room] = response["rooms"]

    assert response["id"] == to_string(user.id)
    assert response["name"] == user.name
    assert response["username"] == user.username

    assert room["name"] == "room name"
    assert room["description"] == "room description"
  end

  test "logout returns string for success", %{conn: conn, user: user, token: token} do
    query = "
      mutation ($refreshToken:String!) {
        logout(refreshToken:$refreshToken)
      }
    "

    variables = %{
      "refreshToken" => token.refresh_token
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("logout")

    assert response == "User logout successfully."
  end

  test "update_profile returns modified user", %{conn: conn, user: user} do
    query = "
      mutation ($input: UpdateProfileInput!) {
        updateProfile(input:$input) {
          email
        }
      }
    "

    variables = %{
      input: %{
        email: "some-updated@email.com"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("updateProfile")

    assert response["email"] == "some-updated@email.com"
  end

  test "change_password returns user modified", %{conn: conn, user: user} do
    query = "
      mutation ($input:ChangePasswordInput!) {
        changePassword(input:$input) {
          id
        }
      }
    "

    variables = %{
      input: %{
        "newPassword" => "test123",
        "oldPassword" => "test"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("changePassword")

    assert response["id"] == to_string(user.id)
  end

  test "delete_user returns string for success", %{conn: conn, user: user} do
    query = "
      mutation {
        deleteUser
      }
    "

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query)
      |> get_query_data("deleteUser")

    assert response == "User deleted succesfully"
  end
end

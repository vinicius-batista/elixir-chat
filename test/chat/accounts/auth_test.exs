defmodule Chat.AuthTest do
  use Chat.DataCase
  alias Chat.Accounts
  alias Chat.Accounts.Auth

  @valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test",
    username: "username"
  }

  setup do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, %{user: %Accounts.User{user | password: nil}}}
  end

  test "check_password returns true for correct password", %{user: user} do
    assert Auth.check_password(user, "test") == true
  end

  test "check_password returns false for incorrect password", %{user: user} do
    assert Auth.check_password(user, "test-password") == false
  end

  test "check_password returns an error if user is nil" do
    assert Auth.check_password(nil, "test") == {:error, "Could not find user with email provided"}
  end

  test "find_user_and_check_password returns user with correct email and pass", %{user: user} do
    user_auth = Auth.find_user_and_check_password("email@email.com", "test")
    assert user_auth == user
  end

  test "find_user_and_check_password returns error with incorrect pass" do
    assert Auth.find_user_and_check_password("email@email.com", "password") ==
             {:error, "Incorrect password"}
  end

  test "find_user_and_check_password returns error with incorrect email" do
    assert Auth.find_user_and_check_password("emaiemail.com", "password") ==
             {:error, "Could not find user with email provided"}
  end
end

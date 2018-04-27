defmodule ChatWeb.Resolvers.AccountResolver do
  alias Chat.Accounts.Auth
  alias Chat.Accounts

  def register_user(_, %{input: input}, _) do
    case Accounts.create_user(input) do
      {:ok, _user} -> {:ok, "User registred successfully."}
      error -> error
    end
  end

  def login_user(_, %{input: %{email: email, password: password}}, _) do
    email
    |> Auth.find_user_and_check_password(password)
    |> Auth.generate_tokens()
  end

  def new_access_token(_, %{refresh_token: refresh_token}, _) do
    refresh_token
    |> Auth.get_user_by_refresh_token()
    |> Auth.generate_new_access_token(refresh_token)
  end

  def profile(_, _, %{context: %{current_user: current_user}}), do: {:ok, current_user}

  def logout(_, %{refresh_token: refresh_token}, %{context: %{current_user: current_user}}) do
    refresh_token
    |> Auth.revoke_refresh_token(current_user.id)
    |> case do
      {:ok, _} -> {:ok, "User logout successfully."}
      error -> error
    end
  end

  def update_profile(_, %{input: input}, %{context: %{current_user: current_user}}) do
    Accounts.update_user(current_user, input)
  end

  def change_password(_, %{input: input}, %{context: %{current_user: current_user}}) do
    current_user
    |> Auth.check_password(input.old_password)
    |> case do
      true -> Accounts.update_user(current_user, %{password: input.new_password})
      false -> {:error, "Old password doesn't match."}
    end
  end

  def delete_user(_, _, %{context: %{current_user: current_user}}) do
    case Accounts.delete_user(current_user) do
      {:ok, _} -> {:ok, "User deleted succesfully"}
      error -> error
    end
  end
end

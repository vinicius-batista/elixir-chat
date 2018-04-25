defmodule ChatWeb.Resolvers.AccountResolver do
  alias Chat.Accounts.Auth
  alias Chat.Accounts
  alias ChatWeb.Guardian

  def register_user(_, %{input: input}, _) do
    case Auth.register(input) do
      {:ok, _user} -> {:ok, "User registred successfully."}
      error -> error
    end
  end

  def login_user(_, %{input: %{email: email, password: password}}, _) do
    case Auth.find_user_and_check_password(email, password) do
      {:ok, user} ->
        user
        |> Guardian.encode_and_sign(%{}, token_type: :bearer)
        |> Auth.generate_refresh_token()

      error ->
        error
    end
  end

  def new_access_token(_, %{refresh_token: refresh_token}, _) do
    refresh_token
    |> Auth.get_user_by_refresh_token()
    |> case do
      {:ok, user} ->
        {:ok, access_token, %{"typ" => type}} =
          user
          |> Guardian.encode_and_sign(%{}, token_type: :bearer)

        tokens =
          %{}
          |> Map.put(:refresh_token, refresh_token)
          |> Map.put(:access_token, access_token)
          |> Map.put(:type, type)

        {:ok, tokens}

      error ->
        error
    end
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
end

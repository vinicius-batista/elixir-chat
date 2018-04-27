defmodule Chat.Accounts.Auth do
  import Ecto.{Query, Changeset}, warn: false
  alias Chat.Repo
  alias Chat.Accounts.{Encryption, User}
  alias Chat.Accounts
  alias ChatWeb.Guardian

  def find_user_and_check_password(email, password) do
    user = Accounts.get_user_by(email: String.downcase(email))

    user
    |> check_password(password)
    |> case do
      true -> user
      false -> {:error, "Incorrect password"}
      error -> error
    end
  end

  def generate_tokens(%User{} = user) do
    user
    |> generate_access_token()
    |> generate_refresh_token()
  end

  def generate_tokens(error), do: error

  defp generate_refresh_token({:ok, access_token, %{"typ" => type, "sub" => user_id}}) do
    %{user_id: user_id, type: type}
    |> Accounts.create_token()
    |> case do
      {:ok, token} ->
        tokens =
          token
          |> Map.from_struct()
          |> Map.put(:access_token, access_token)
          |> Map.take([:access_token, :refresh_token, :type])

        {:ok, tokens}

      error ->
        error
    end
  end

  def generate_new_access_token({:ok, user}, refresh_token) do
    {:ok, access_token, %{"typ" => type}} =
      user
      |> generate_access_token()

    tokens =
      %{}
      |> Map.put(:refresh_token, refresh_token)
      |> Map.put(:access_token, access_token)
      |> Map.put(:type, type)

    {:ok, tokens}
  end

  def generate_new_access_token(error, _), do: error

  def get_user_by_refresh_token(refresh_token) do
    %{refresh_token: refresh_token, is_revoked: false}
    |> Accounts.get_token_by()
    |> load_user()
  end

  defp load_user(nil), do: {:error, "Could not find user with refresh token provided"}

  defp load_user(token) do
    user =
      token
      |> Repo.preload(:user)
      |> Map.get(:user)

    {:ok, user}
  end

  defp generate_access_token(user), do: Guardian.encode_and_sign(user, %{}, token_type: :bearer)

  def revoke_refresh_token(refresh_token, user_id) do
    %{refresh_token: refresh_token, is_revoked: false, user_id: user_id}
    |> Accounts.get_token_by()
    |> revoke_token()
  end

  defp revoke_token(nil), do: {:error, "Could not find refresh token provided"}

  defp revoke_token(token) do
    token
    |> Accounts.update_token(%{is_revoked: true})
  end

  def check_password(user, password) do
    case user do
      nil -> {:error, "Could not find user with email provided"}
      user -> Encryption.validate_password(password, user.password_hash)
    end
  end
end

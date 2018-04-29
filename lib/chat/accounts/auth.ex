defmodule Chat.Accounts.Auth do
  alias Chat.Repo
  alias Chat.Accounts.{Encryption, AuthToken}
  alias Chat.Accounts

  def find_user_and_check_password(email, password) do
    user = Accounts.get_user_by(email: String.downcase(email))

    user
    |> check_password(password)
    |> case do
      true -> {:ok, user}
      false -> {:error, "Incorrect password"}
      error -> error
    end
  end

  def generate_tokens(user) do
    with {:ok, access_token, claims} <- AuthToken.generate_access_token(user) do
      AuthToken.generate_refresh_token(access_token, claims)
    end
  end

  def generate_new_access_token(user, refresh_token) do
    {:ok, access_token, %{"typ" => type}} =
      user
      |> AuthToken.generate_access_token()

    tokens =
      %{}
      |> Map.put(:refresh_token, refresh_token)
      |> Map.put(:access_token, access_token)
      |> Map.put(:type, type)

    {:ok, tokens}
  end

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

  def revoke_refresh_token(refresh_token, user_id) do
    %{refresh_token: refresh_token, is_revoked: false, user_id: user_id}
    |> Accounts.get_token_by()
    |> AuthToken.revoke_token()
  end

  def check_password(user, password) do
    case user do
      nil -> {:error, "Could not find user with email provided"}
      user -> Encryption.validate_password(password, user.password_hash)
    end
  end
end

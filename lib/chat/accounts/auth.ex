defmodule Chat.Accounts.Auth do
  import Ecto.{Query, Changeset}, warn: false
  alias Chat.Repo
  alias Chat.Accounts.{Encryption, User}
  alias Chat.Accounts

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> hash_password
    |> Repo.insert()
  end

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

  def generate_refresh_token({:ok, access_token, %{"typ" => type, "sub" => user_id}}) do
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
    |> revoke_token()
  end

  defp revoke_token(nil), do: {:error, "Could not find refresh token provided"}

  defp revoke_token(token) do
    token
    |> Accounts.update_token(%{is_revoked: true})
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        changeset
        |> put_change(:password, Encryption.password_hashing(pass))

      _ ->
        changeset
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> {:error, "Could not find user with email provided"}
      user -> Encryption.validate_password(password, user.password)
    end
  end
end

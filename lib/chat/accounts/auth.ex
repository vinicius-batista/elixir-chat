defmodule Chat.Accounts.Auth do
  import Ecto.{Query, Changeset}, warn: false
  alias Chat.Repo
  alias Chat.Accounts.{Encryption, User, Token}
  alias Chat.Accounts

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> hash_password
    |> Repo.insert()
  end

  def find_user_and_check_password(email, password) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect password"}
      error -> error
    end
  end

  def generate_refresh_token({:ok, token, %{"typ" => type, "sub" => user_id}}) do
    case Accounts.create_token(%{user_id: user_id, type: type}) do
      {:ok, %Token{refresh_token: refresh_token, type: type}} ->
        tokens = %{
          refresh_token: refresh_token,
          type: type,
          access_token: token
        }

        {:ok, tokens}

      error ->
        error
    end
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Encryption.password_hashing(pass))

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

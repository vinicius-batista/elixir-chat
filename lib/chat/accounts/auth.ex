defmodule Chat.Accounts.Auth do

  import Ecto.{Query, Changeset}, warn: false
  alias Chat.Repo
  alias Chat.Accounts.Encryption
  alias Chat.Accounts.User

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> hash_password
    |> Repo.insert
  end

  defp hash_password(changeset) do
    case changeset do
       %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
          put_change(changeset, :password,  Encryption.password_hashing(pass))
       _ -> changeset
    end
  end
end

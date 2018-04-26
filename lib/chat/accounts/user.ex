defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.{Token, Encryption}

  @email_regex ~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/
  @required_fields ~w(email name password_hash username)a
  @all_fields ~w(password)a ++ @required_fields
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:username, :string)
    field(:password_hash, :string)

    timestamps()
    has_many(:tokens, Token, on_delete: :delete_all)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:username, name: :users_username_index)
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:password_hash, Encryption.password_hashing(pass))
  end

  defp hash_password(changeset), do: changeset
end

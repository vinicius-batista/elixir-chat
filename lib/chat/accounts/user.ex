defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.{Token, Encryption}
  alias Chat.Rooms.Room

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
    has_many(:rooms, Room, on_delete: :delete_all, foreign_key: :owner_id)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> hash_password()
    |> validate_required(@required_fields)
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:username, name: :users_username_index)
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:password_hash, Encryption.password_hashing(pass))
  end

  defp hash_password(changeset), do: changeset

  def data() do
    Dataloader.Ecto.new(Chat.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end

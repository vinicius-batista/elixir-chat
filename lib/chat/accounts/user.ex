defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @email_regex ~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/
  @required_fields ~w(email name password username)a
  @all_fields ~w()a ++ @required_fields
  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :username, :string

    timestamps()
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
  end
end

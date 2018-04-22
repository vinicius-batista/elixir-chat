defmodule Chat.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.User

  @required_fields ~w(token user_id)a
  @all_fields ~w(is_revoked type)a ++ @required_fields
  schema "tokens" do
    field(:token, :string)
    field(:is_revoked, :boolean, default: false)
    field(:type, :string, default: "refresh")

    timestamps()
    belongs_to(:user, User, foreign_key: :user_id)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, @all_fields)
    |> put_change(:token, Ecto.UUID.generate())
    |> validate_required(@required_fields)
    |> unique_constraint(:token, name: :tokens_token_index)
  end
end

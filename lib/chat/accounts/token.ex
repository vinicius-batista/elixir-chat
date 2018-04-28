defmodule Chat.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.User

  @required_fields ~w(refresh_token user_id)a
  @all_fields ~w(is_revoked type)a ++ @required_fields
  schema "tokens" do
    field(:refresh_token, :string)
    field(:is_revoked, :boolean, default: false)
    field(:type, :string, default: "bearer")

    timestamps()
    belongs_to(:user, User, foreign_key: :user_id)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, @all_fields)
    |> generate_refresh_token()
    |> validate_required(@required_fields)
    |> unique_constraint(:refresh_token, name: :tokens_refresh_token_index)
  end

  defp generate_refresh_token(changeset) do
    with nil <- get_field(changeset, :refresh_token, nil) do
      changeset
      |> put_change(:refresh_token, Ecto.UUID.generate())
    else
      _ -> changeset
    end
  end
end

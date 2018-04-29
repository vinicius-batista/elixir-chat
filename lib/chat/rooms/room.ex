defmodule Chat.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.User

  @required_fields ~w(name description owner_id)a
  @all_fields ~w()a ++ @required_fields
  schema "rooms" do
    field(:description, :string)
    field(:name, :string)

    timestamps()
    belongs_to(:owner, User, foreign_key: :owner_id)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end

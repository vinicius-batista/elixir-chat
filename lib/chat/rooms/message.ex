defmodule Chat.Rooms.Message do
  @moduledoc """
  Message Schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.User
  alias Chat.Rooms.Room

  @required_fields ~w(text user_id room_id)a
  @all_fields ~w()a ++ @required_fields
  schema "messages" do
    field(:text, :string)

    timestamps()
    belongs_to(:user, User, foreign_key: :user_id)
    belongs_to(:room, Room, foreign_key: :room_id)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end

defmodule ChatWeb.Schema.MessagesTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Chat.Accounts.User
  alias Chat.Room.Room

  @desc "Message type"
  object :message do
    field(:id, :id)
    field(:text, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:user, :user, resolve: dataloader(User))
    field(:room, :room, resolve: dataloader(Room))
  end
end

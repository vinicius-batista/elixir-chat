defmodule ChatWeb.Schema.RoomsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Chat.Accounts.User

  @desc "Room object"
  object :room do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
    field(:owner, :user, resolve: dataloader(User))
  end
end

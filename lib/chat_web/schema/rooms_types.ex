defmodule ChatWeb.Schema.RoomsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Chat.Accounts.User
  alias ChatWeb.Middlewares.{Authentication, HandleErrors}
  alias ChatWeb.Resolvers.RoomsResolvers

  @desc "Room object"
  object :room do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
    field(:owner, :user, resolve: dataloader(User))
  end

  input_object :create_room_input do
    field(:name, :string)
    field(:description, :string)
  end

  input_object :update_room_input do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
  end

  @desc "Room mutations"
  object :rooms_mutations do
    field :create_room, :room do
      arg(:input, non_null(:create_room_input))
      middleware(Authentication)
      resolve(&RoomsResolvers.create_room/3)
      middleware(HandleErrors)
    end

    field :update_room, :room do
      arg(:input, non_null(:update_room_input))
      middleware(Authentication)
      resolve(&RoomsResolvers.update_room/3)
      middleware(HandleErrors)
    end
  end
end

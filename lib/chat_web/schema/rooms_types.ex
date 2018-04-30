defmodule ChatWeb.Schema.RoomsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Chat.Accounts.User
  alias Chat.Rooms.Message
  alias ChatWeb.Middlewares.{Authentication, HandleErrors}
  alias ChatWeb.Resolvers.RoomsResolvers

  @desc "Room object"
  object :room do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:owner, :user, resolve: dataloader(User))

    field :messages, list_of(:message) do
      arg(:limit, :integer, default_value: 20)
      arg(:cursor, :string, default_value: DateTime.utc_now())
      resolve(dataloader(Message))
    end
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

    field :delete_room, :string do
      arg(:id, :integer)
      middleware(Authentication)
      resolve(&RoomsResolvers.delete_room/3)
      middleware(HandleErrors)
    end
  end

  object :rooms_queries do
    field :rooms, list_of(:room) do
      arg(:name, non_null(:string))
      arg(:limit, :integer, default_value: 20)
      arg(:cursor, :string, default_value: DateTime.utc_now())
      middleware(Authentication)
      resolve(&RoomsResolvers.get_rooms/3)
    end
  end
end

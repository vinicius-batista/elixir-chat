defmodule ChatWeb.Schema.MessagesTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Chat.Accounts.User
  alias Chat.Room.Room
  alias ChatWeb.Middlewares.{Authentication, HandleErrors}
  alias ChatWeb.Resolvers.MessagesResolvers

  @desc "Message type"
  object :message do
    field(:id, :id)
    field(:text, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:user, :user, resolve: dataloader(User))
    field(:room, :room, resolve: dataloader(Room))
  end

  input_object :create_message_input do
    field(:text, :string)
    field(:room_id, :integer)
  end

  @desc "Messages Mutations"
  object :messages_mutations do
    field :create_message, :message do
      arg(:input, non_null(:create_message_input))
      middleware(Authentication)
      resolve(&MessagesResolvers.create_message/3)
      middleware(HandleErrors)
    end
  end

  object :messages_subscriptions do
    field :message_added, :message do
      arg(:room_id, non_null(:integer))

      config(fn args, %{context: context} ->
        if Map.has_key?(context, :current_user) do
          {:ok, topic: args.room_id}
        else
          {:ok, topic: nil}
        end
      end)

      trigger(
        :create_message,
        topic: fn message ->
          message.room_id
        end
      )
    end
  end
end
defmodule ChatWeb.Schema do
  @moduledoc """
  Graphql Schema
  """
  use Absinthe.Schema

  alias Absinthe.Middleware.Dataloader
  alias Absinthe.Plugin
  alias ChatWeb.Schema.{AccountsTypes, MessagesTypes, RoomsTypes}

  import_types(Absinthe.Type.Custom)
  import_types(AccountsTypes)
  import_types(RoomsTypes)
  import_types(MessagesTypes)
  import_types(Absinthe.Plug.Types)

  query do
    import_fields(:account_queries)
    import_fields(:rooms_queries)
    import_fields(:messages_queries)
  end

  mutation do
    import_fields(:account_mutations)
    import_fields(:rooms_mutations)
    import_fields(:messages_mutations)
  end

  subscription do
    import_fields(:messages_subscriptions)
  end

  def plugins do
    [Dataloader] ++ Plugin.defaults()
  end
end

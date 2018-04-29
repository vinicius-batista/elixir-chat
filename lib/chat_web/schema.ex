defmodule ChatWeb.Schema do
  use Absinthe.Schema

  alias ChatWeb.Schema.{AccountsTypes, RoomsTypes, MessagesTypes}

  import_types(Absinthe.Type.Custom)
  import_types(AccountsTypes)
  import_types(RoomsTypes)
  import_types(MessagesTypes)

  query do
    import_fields(:account_queries)
    import_fields(:rooms_queries)
  end

  mutation do
    import_fields(:account_mutations)
    import_fields(:rooms_mutations)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end

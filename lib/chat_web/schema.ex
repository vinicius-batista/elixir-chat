defmodule ChatWeb.Schema do
  use Absinthe.Schema

  alias ChatWeb.Schema.{AccountsTypes, RoomsTypes}

  import_types(Absinthe.Type.Custom)
  import_types(AccountsTypes)
  import_types(RoomsTypes)

  query do
    import_fields(:account_queries)
  end

  mutation do
    import_fields(:account_mutations)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end

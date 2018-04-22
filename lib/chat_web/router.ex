defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :graphql do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:graphql)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: ChatWeb.Schema,
      interface: :advanced
    )

    forward("/graphql", Absinthe.Plug, schema: ChatWeb.Schema)
  end
end

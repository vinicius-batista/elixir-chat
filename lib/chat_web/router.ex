defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ChatWeb.Schema

    forward "/graphql", Absinthe.Plug,
      schema: ChatWeb.Schema
  end
end

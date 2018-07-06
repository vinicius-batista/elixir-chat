defmodule ChatWeb.Router do
  @moduledoc """
  Module for Router
  """
  use ChatWeb, :router

  alias ChatWeb.DownloadController

  pipeline :graphql do
    plug(:accepts, ["json"])
    plug(ChatWeb.Context)
  end

  scope "/" do
    pipe_through(:graphql)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: ChatWeb.Schema,
      socket: ChatWeb.UserSocket,
      interface: :advanced
    )

    forward("/graphql", Absinthe.Plug, schema: ChatWeb.Schema)
  end

  scope "/download" do
    get("/:folder/:file", DownloadController, :show)
  end
end

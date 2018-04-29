defmodule ChatWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias ChatWeb.Helpers.BuildLoader
  alias Chat.Accounts.AuthToken

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    conn
    |> get_req_header("authorization")
    |> case do
      ["Bearer " <> token] -> AuthToken.authorize(token)
      _ -> %{}
    end
    |> BuildLoader.build()
  end
end

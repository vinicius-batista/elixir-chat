defmodule ChatWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias ChatWeb.Guardian
  alias Chat.Rooms.Room
  alias Chat.Accounts.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    conn
    |> get_req_header("authorization")
    |> case do
      ["Bearer " <> token] -> authorize(token)
      _ -> %{}
    end
    |> build_loader()
  end

  def build_loader(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Room, Room.data())
      |> Dataloader.add_source(User, User.data())

    Map.put(ctx, :loader, loader)
  end

  defp authorize(token) do
    case Guardian.resource_from_token(token) do
      {:error, _} -> %{}
      {:ok, current_user, _claims} -> %{current_user: current_user}
    end
  end
end

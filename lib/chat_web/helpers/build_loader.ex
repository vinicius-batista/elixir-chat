defmodule ChatWeb.Helpers.BuildLoader do
  @moduledoc """
  Configure Dataloader for Graphql
  """
  import Ecto.Query, warn: false
  alias Chat.Accounts.User
  alias Chat.Rooms.{Message, Room}
  alias Dataloader.Ecto

  def build(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Room, data())
      |> Dataloader.add_source(User, data())
      |> Dataloader.add_source(Message, data())

    Map.put(ctx, :loader, loader)
  end

  defp data do
    Ecto.new(Chat.Repo, query: &query/2)
  end

  defp query(Message, params) do
    from(
      message in Message,
      where: message.inserted_at < ^params[:cursor],
      order_by: [desc: message.id],
      limit: ^params[:limit]
    )
  end

  defp query(queryable, _params) do
    queryable
  end
end

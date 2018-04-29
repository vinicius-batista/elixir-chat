defmodule ChatWeb.Helpers.BuildLoader do
  import Ecto.Query, warn: false
  alias Chat.Rooms.{Room, Message}
  alias Chat.Accounts.User

  def build(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Room, data())
      |> Dataloader.add_source(User, data())
      |> Dataloader.add_source(Message, data())

    Map.put(ctx, :loader, loader)
  end

  defp data() do
    Dataloader.Ecto.new(Chat.Repo, query: &query/2)
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

defmodule ChatWeb.DownloadController do
  @moduledoc """
  Controller for download images
  """
  use ChatWeb, :controller
  alias Chat.Images

  def show(conn, params) do
    path = "/#{params["folder"]}/#{params["file"]}"

    with {:ok, file} <- Images.download(path) do
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_resp(200, file)
    else
      _ ->
        conn
        |> send_resp(404, "")
    end
  end
end

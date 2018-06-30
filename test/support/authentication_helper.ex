defmodule ChatWeb.AuthenticationHelper do
  @moduledoc """
  Test helper for handle authentication
  """
  alias ChatWeb.Guardian
  alias Plug.Conn

  def authenticate_user(conn, user) do
    {:ok, token, _} =
      user
      |> Guardian.encode_and_sign(%{}, token_type: :bearer)

    conn
    |> Conn.put_req_header("authorization", "Bearer #{token}")
  end
end

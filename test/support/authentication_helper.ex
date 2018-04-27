defmodule ChatWeb.AuthenticationHelper do
  alias ChatWeb.Guardian

  def authenticate_user(conn, user) do
    {:ok, token, _} =
      user
      |> Guardian.encode_and_sign(%{}, token_type: :bearer)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
  end
end

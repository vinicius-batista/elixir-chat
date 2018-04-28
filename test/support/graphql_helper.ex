defmodule ChatWeb.GraphqlHelper do
  use Phoenix.ConnTest

  @endpoint ChatWeb.Endpoint

  def graphql_query(conn, options) do
    conn
    |> post("/graphql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  def get_query_data(conn, query), do: conn["data"][query]

  defp build_query(query, variables) do
    %{
      query: query,
      variables: variables
    }
  end
end

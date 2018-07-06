defmodule Chat.Images.UploadType do
  @moduledoc """
  Upload Ecto Type
  """
  @behaviour Ecto.Type

  def type(), do: :map

  def cast(%Plug.Upload{} = upload), do: {:ok, upload}
  def cast(_), do: :error

  def load(upload), do: {:ok, upload}

  def dump(upload), do: {:ok, upload}
end

defmodule Chat.Images do
  @moduledoc """
  Module for handle upload/download for images
  """

  @spec upload(%Plug.Upload{}, String.t()) :: String.t()
  def upload(file, dirname) do
    with filename <- hash_filename(file.filename),
         {:ok, image} <- File.read(file.path),
         :ok <- create_dir(dirname) do
      path = "/#{dirname}/#{filename}.jpg"

      :ok =
        ("uploads" <> path)
        |> File.write(image)

      path
    end
  end

  @spec download(String.t()) :: :binary.t()
  def download(path) do
    ("uploads" <> path)
    |> File.read()
  end

  @spec create_dir(String.t()) :: File.mkdir()
  def create_dir(dirname) do
    path = "uploads/#{dirname}"

    case File.dir?(path) do
      true -> :ok
      _ -> File.mkdir(path)
    end
  end

  @spec hash_filename(String.t()) :: String.t()
  def hash_filename(filename) do
    now =
      DateTime.utc_now()
      |> DateTime.to_string()

    :crypto.hash(:md5, now <> filename)
    |> Base.encode16()
  end
end

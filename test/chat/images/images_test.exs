defmodule Chat.ImagesTest do
  @moduledoc """
  Images context test
  """

  alias Chat.Images
  use ExUnit.Case

  describe "Images" do
    setup do
      path =
        %{
          path: "test/support/test_image.jpg",
          content_type: "jpg",
          filename: "Some random name"
        }
        |> Images.upload("test")

      %{path: path}
    end

    test "hash_filename/1 should return random string" do
      string = "Some random name"
      random_string = Images.hash_filename(string)
      assert string != random_string
      assert String.valid?(random_string)
    end

    test "upload/2 should upload an image and return path" do
      upload = %{
        path: "test/support/test_image.jpg",
        content_type: "jpg",
        filename: "Some random name"
      }

      path = Images.upload(upload, "test")

      assert String.valid?(path)

      {:ok, image} =
        ("uploads" <> path)
        |> File.read()

      assert is_binary(image)
    end

    test "download/1 should return an image binary", %{path: path} do
      {:ok, image} = Images.download(path)
      assert is_binary(image)
    end
  end
end

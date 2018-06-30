defmodule Chat.EncryptionTest do
  @moduledoc """
  Encryption module test
  """
  use Chat.DataCase
  alias Chat.Accounts.Encryption

  @password "test-password"

  test "password_hashing return encrypted password" do
    password_hash = Encryption.password_hashing(@password)
    assert password_hash != @password
  end

  test "validate_password return true for equal password" do
    password_hash = Encryption.password_hashing(@password)
    assert Encryption.validate_password(@password, password_hash) == true
  end

  test "validate_password return false for wrong password" do
    password_hash = Encryption.password_hashing(@password)
    assert Encryption.validate_password("testpassword", password_hash) == false
  end
end

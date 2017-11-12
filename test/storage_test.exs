defmodule StorageTest do
  use ExUnit.Case, async: true
  doctest Agata.Storage

  setup do
    Agata.Storage.flush

    on_exit fn -> Agata.Storage.flush end

    :ok
  end

  test "set" do
    refute Agata.Storage.get("foo")

    Agata.Storage.set("foo", "bar")

    assert Agata.Storage.get("foo") == "bar"
  end

  test "all" do
    Agata.Storage.set(2, "bar")
    Agata.Storage.set(1, "foo")

    assert Agata.Storage.all == [{1, "foo"}, {2, "bar"}]
  end

  test "to_json" do
    Agata.Storage.set(2, "bar")
    Agata.Storage.set(1, "foo")

    assert Agata.Storage.to_json == "[\"foo\",\"bar\"]"
  end
end

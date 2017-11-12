defmodule ClientsTest do
  use ExUnit.Case
  doctest Agata.Clients

  setup do
    Agata.Clients.flush

    on_exit fn -> Agata.Clients.flush end

    :ok
  end

  test "join" do
    assert Agata.Clients.clients |> Enum.empty?

    Agata.Clients.join(spawn fn -> 1 end)

    assert Agata.Clients.clients |> Enum.count == 1
  end

  test "leave" do
    pid = spawn fn -> 1 end

    Agata.Clients.join(pid)

    assert Agata.Clients.clients |> Enum.member?(pid)

    Agata.Clients.leave(pid)

    refute Agata.Clients.clients |> Enum.member?(pid)
  end

  test "send_message" do
    pid = spawn fn -> receive do true -> true end end

    Agata.Clients.join(pid)

    Agata.Clients.send_message(:ok)

    Process.sleep(1)

    assert {:messages, [send_message: :ok]} == Process.info(pid, :messages)

    Process.exit(pid, :kill)
  end
end

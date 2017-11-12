defmodule Agata.SocketHandler do
  @behaviour :cowboy_websocket

  def init(_, _, _) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  @timeout Application.get_env(:agata, :web_socket_timeout)

  def websocket_init(_, req, _) do
    Agata.Clients.join(self())

    {:ok, req, %{}, @timeout}
  end

  def websocket_info({:send_message, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:text, "read," <> id}, req, state) do
    Agata.Storage.mark_as_read(String.to_integer(id))

    {:ok, req, state}
  end

  def websocket_handle({:text, _}, req, state) do
    {:ok, req, state}
  end

  def websocket_terminate(_, _, _) do
    Agata.Clients.leave(self())

    :ok
  end
end

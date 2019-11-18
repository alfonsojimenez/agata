defmodule Agata.SocketHandler do
  @behaviour :cowboy_websocket

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(_state) do
    Agata.Clients.join(self())

    {:ok, %{}}
  end

	def websocket_handle({:text, "read," <> id}, state) do
		Agata.Storage.mark_as_read(String.to_integer(id))

		{:ok, state}
	end

  def websocket_handle({:noreply, _}, state) do
    {:ok, state}
  end

  def websocket_info({:send_message, message}, state) do
    {:reply, {:text, message}, state}
  end

  def terminate(_reason, _req, _state) do
    Agata.Clients.leave(self())

    :ok
  end
end

defmodule Agata.Clients do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  def join(pid) do
    GenServer.cast(__MODULE__, {:join, pid})
  end

  def leave(pid) do
    GenServer.cast(__MODULE__, {:leave, pid})
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, {:send_message, message})
  end

  def clients do
    GenServer.call(__MODULE__, :clients)
  end

  def flush do
    GenServer.call(__MODULE__, :flush)
  end

  def terminate(_, _) do
    :ok
  end

  def handle_cast({:join, pid}, state) do
    {:noreply, [pid|state]}
  end

  def handle_cast({:leave, pid}, state) do
    {:noreply, state -- [pid]}
  end

  def handle_cast({:send_message, message}, state) do
    Enum.each(state, &(send(&1, {:send_message, message})))

    {:noreply, state}
  end

  def handle_call(:clients, _, state) do
    {:reply, state, state}
  end

  def handle_call(:flush, _, _) do
    {:reply, :ok, []}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end

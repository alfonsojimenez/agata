defmodule Agata.Storage do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:table_name, :"agata_table_#{Mix.env}"},
      {:log_limit, 1_000_000}
    ], opts)
  end

  def init(args) do
    [{:table_name, table_name}, {:log_limit, log_limit}] = args

    :ets.new(table_name, [:named_table, :ordered_set, :public])

    {:ok, %{log_limit: log_limit, table_name: table_name}}
  end

  def get(key) do
    case GenServer.call(__MODULE__, {:get, key}) do
      [] -> nil
      [{_, result}] -> result
    end
  end

  def set(key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def flush do
    GenServer.call(__MODULE__, :flush)
  end

  def to_json do
    GenServer.call(__MODULE__, :to_json)
  end

  def mark_as_read(id) do
    GenServer.call(__MODULE__, {:mark_as_read, id})
  end

  def handle_call({:get, key}, _, state) do
    %{table_name: table_name} = state

    result = :ets.lookup(table_name, key)

    {:reply, result, state}
  end

  def handle_call({:set, key, value}, _, state) do
    %{table_name: table_name} = state

    true = :ets.insert(table_name, {key, value})

    {:reply, value, state}
  end

  def handle_call(:all, _, state) do
    %{table_name: table_name} = state

    {:reply, :ets.tab2list(table_name), state}
  end

  def handle_call(:flush, _, state) do
    %{table_name: table_name} = state

    {:reply, :ets.delete_all_objects(table_name), state}
  end

  def handle_call(:to_json, _, state) do
    %{table_name: table_name} = state

    result = :ets.tab2list(table_name)
             |> Enum.map(fn v -> elem(v, 1) end)
             |> Poison.encode!

    {:reply, result, state}
  end

  def handle_call({:mark_as_read, key}, _, state) do
    %{table_name: table_name} = state

    item = case :ets.lookup(table_name, key) do
      [{_, item}] -> :ets.insert(table_name, {key, Map.put(item, :unread, false)})
      _ -> false
    end

    {:reply, item, state}
  end
end

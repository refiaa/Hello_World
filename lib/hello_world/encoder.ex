defmodule HelloWorld.Encoder do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  def encode(data) do
    GenServer.call(__MODULE__, {:encode, data})
  end

  def decode(encoded_data) do
    GenServer.call(__MODULE__, {:decode, encoded_data})
  end

  @impl true
  def handle_call({:encode, data}, _from, state) do
    result = %{encoded: Base.encode64(data), data: data}
    {:reply, result, state}
  end

  @impl true
  def handle_call({:decode, encoded_data}, _from, state) do
    case Base.decode64(encoded_data) do
      {:ok, decoded} -> {:reply, decoded, state}
      :error -> {:reply, encoded_data, state}
    end
  end
end

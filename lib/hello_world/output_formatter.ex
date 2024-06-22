defmodule HelloWorld.OutputFormatter do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  def format(data) do
    GenServer.call(__MODULE__, {:format, data})
  end

  @impl true
  def handle_call({:format, data}, _from, state) do
    formatted = Jason.encode!(data, pretty: true)
    IO.puts("Intermediate result:")
    IO.puts(formatted)
    {:reply, formatted, state}
  end
end

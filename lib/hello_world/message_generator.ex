defmodule HelloWorld.MessageGenerator do
  use GenServer

  @alphabet Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ [?\s, ?!]

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{seed: :os.system_time()}}
  end

  def get_message do
    GenServer.call(__MODULE__, :get_message)
  end

  @impl true
  def handle_call(:get_message, _from, state) do
    message = generate_message(state.seed)
    {:reply, message, %{state | seed: :os.system_time()}}
  end

  defp generate_message(seed) do
    :rand.seed(:exsss, {seed, seed, seed})
    target = [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33]
    Enum.map(target, &generate_char/1)
    |> Enum.join()
  end

  defp generate_char(target) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(Enum.random(@alphabet), fn _, acc ->
      if acc == target do
        {:halt, <<acc::utf8>>}
      else
        {:cont, Enum.random(@alphabet)}
      end
    end)
  end
end

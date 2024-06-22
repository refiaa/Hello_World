defmodule HelloWorld.Hasher do
  use GenServer

  @salt_bytes 16
  @pepper "SuperSecretPepper"

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  def hash(data) do
    GenServer.call(__MODULE__, {:hash, data})
  end

  def unhash(hash, salt) do
    GenServer.call(__MODULE__, {:unhash, hash, salt})
  end

  @impl true
  def handle_call({:hash, %{data: data, encrypted: encrypted}}, _from, state) do
    salt = :crypto.strong_rand_bytes(@salt_bytes)
    peppered_data = data <> @pepper
    salted_data = peppered_data <> salt
    hashed = :crypto.hash(:sha256, salted_data)
    result = %{
      hash: Base.encode16(hashed),
      salt: Base.encode16(salt),
      data: data,
      encrypted: encrypted
    }
    {:reply, result, state}
  end

  @impl true
  def handle_call({:unhash, hash, salt}, _from, state) do
    {:reply, :crypto.hash(:sha256, hash <> salt), state}
  end
end

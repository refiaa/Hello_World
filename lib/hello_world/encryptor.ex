defmodule HelloWorld.Encryptor do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  def encrypt(data) do
    GenServer.call(__MODULE__, {:encrypt, data})
  end

  def decrypt(encrypted_data) do
    GenServer.call(__MODULE__, {:decrypt, encrypted_data})
  end

  @impl true
  def handle_call({:encrypt, %{data: data}}, _from, state) do
    key = :crypto.strong_rand_bytes(32)
    iv = :crypto.strong_rand_bytes(16)
    encrypted = :crypto.crypto_one_time(:aes_256_cbc, key, iv, pad(data), true)
    result = %{encrypted: Base.encode64(iv <> key <> encrypted), data: data}
    {:reply, result, state}
  end

  @impl true
  def handle_call({:decrypt, encrypted_data}, _from, state) do
    <<iv::binary-16, key::binary-32, encrypted::binary>> = Base.decode64!(encrypted_data)
    decrypted = :crypto.crypto_one_time(:aes_256_cbc, key, iv, encrypted, false)
    unpadded = unpad(decrypted)
    {:reply, unpadded, state}
  end

  defp pad(data) do
    bytes_to_pad = 16 - rem(byte_size(data), 16)
    data <> :binary.copy(<<bytes_to_pad>>, bytes_to_pad)
  end

  defp unpad(data) do
    <<_::binary-size(byte_size(data)-1), last_byte>> = data
    binary_part(data, 0, byte_size(data) - last_byte)
  end
end

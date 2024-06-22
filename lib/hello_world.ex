defmodule HelloWorld do
  alias HelloWorld.{MessageGenerator, Encoder, Encryptor, Hasher, OutputFormatter}

  def run do
    MessageGenerator.get_message()
    |> Encoder.encode()
    |> Encryptor.encrypt()
    |> Hasher.hash()
    |> OutputFormatter.format()
    |> Jason.decode!()
    |> decrypt_and_decode()
    |> IO.puts()
  end

  defp decrypt_and_decode(%{"encrypted" => encrypted, "data" => data}) do
    decrypted = Encryptor.decrypt(encrypted)
    case decrypted do
      ^data -> data
      _ -> Encoder.decode(decrypted)
    end
  end
end

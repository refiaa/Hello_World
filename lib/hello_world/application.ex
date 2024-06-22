defmodule HelloWorld.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HelloWorld.MessageGenerator,
      HelloWorld.Encoder,
      HelloWorld.Encryptor,
      HelloWorld.Hasher,
      HelloWorld.OutputFormatter
    ]

    opts = [strategy: :one_for_one, name: HelloWorld.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

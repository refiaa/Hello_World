defmodule Mix.Tasks.Hello do
  use Mix.Task

  def run(_) do
    HelloWorld.run()
  end
end

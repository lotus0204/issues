defmodule SpawnLink3 do
  import :timer, only: [sleep: 1]

  def child(parent) do
    send(parent, {:ok, "Hello"})
    exit(:gone)
  end

  def run do
    spawn_monitor(SpawnLink3, :child, [self()])

    sleep(500)

    receive do
      {:ok, message} ->
        IO.puts("MESSAGE RECEIVED: #{inspect(message)}")
    end
  end
end

SpawnLink3.run
# MESSAGE RECEIVED: "Hello"

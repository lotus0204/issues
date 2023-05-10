defmodule SpawnLink2 do
  import :timer, only: [sleep: 1]

  def child() do
    # send(parent, {:ok, "Hello"})
    # exit(:gone)
    raise "boom"
  end

  def run do
    spawn_link(SpawnLink, :child, [])

    sleep(500)

    receive do
      {:ok, message} ->
        IO.puts("MESSAGE RECEIVED: #{inspect(message)}")
    end
  end
end

SpawnLink2.run

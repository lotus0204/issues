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
# ** (EXIT from #PID<0.95.0>) an exception was raised:
#     ** (UndefinedFunctionError) function SpawnLink.child/0 is undefined (module SpawnLink is not available)
#         SpawnLink.child()

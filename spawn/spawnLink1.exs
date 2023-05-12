defmodule SpawnLink do
  import :timer, only: [sleep: 1]

  def child(parent) do
    send(parent, {:ok, "Hello"})
    exit(:boom)
  end

  def run do
    spawn_link(SpawnLink, :child, [self()])

    sleep(500)

    receive do
      {:ok, message} ->
        IO.puts("MESSAGE RECEIVED: #{inspect(message)}")
    end
  end
end

SpawnLink.run
# child가 비정상적으로 종료되었기 때문에 부모 프로세스도 그냥 종료되었음 spawn_link는 원래 그래
# ** (EXIT from #PID<0.95.0>) :boom

defmodule SpawnLink3 do
  import :timer, only: [sleep: 1]

  def child(parent) do
    send(parent, {:ok, "Hello"})
    exit(:boom)
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
# 메시지를 보내고 죽었는데도 받을 수 있네. sleep 중이었는데도 받는 것 같은게 신기

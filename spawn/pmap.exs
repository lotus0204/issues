defmodule Parallel do
  def pmap(collection, fun) do
    me = self()
    collection
    |> Enum.map(fn(elem) ->
          # spawn_link fn -> (send self(), {self(), fun.(elem)}) end
          spawn_link fn -> (send me, {self(), fun.(elem)}) end
       end)
    |> Enum.map(fn (pid) ->
          Process.sleep(1000)  # 1초 동안 프로세스를 멈춤
          # receive do {^pid, result} -> result end
          receive do {_pid, result} -> result end
       end)
  end
end

# 1. self()를 한번만 호출하기 위해서?
# 2. _pid는 와일드 카드 패턴이기 때문에 어떤 pid에 대해서도 모두 되기 때문에 문제가 있는 코드이다.

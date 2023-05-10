defmodule Token do
  def process do
    receive do
      {sender, msg} ->
        send sender, { :ok, "#{msg}"}
        process()
    end
  end
end

fred_pid = spawn(Token, :process, [])
betty_pid = spawn(Token, :process, [])

send fred_pid, {self, 'fred'}
receive do
  {:ok, message} ->
    IO.puts message
end

send betty_pid, {self, 'betty'}
receive do
  {:ok, message} ->
    IO.puts message
end
# 계속 해봤는데 순서대로 들어오는 것처럼 보인다. 그래도 순서를 보장하기 위해서는 task,getserver?

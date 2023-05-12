;defmodule Token do
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

send fred_pid, {self(), 'fred'}
send betty_pid, {self(), 'betty'}


receive do
  # {:ok, message} ->
  #   IO.puts message
  {:ok, message} when message == "fred" ->
    IO.puts message
end

# send betty_pid, {self(), 'betty'}
receive do
  # {:ok, message} ->
  #   IO.puts message
  {:ok, message} when message == "betty" ->
    IO.puts message
end
# 계속 해봤는데 아주 가끔식 순서가 보장되지 않는다.
# 순서를 보장하기 위해서는 메시지에 when을 달면된다.

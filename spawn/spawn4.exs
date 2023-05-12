defmodule Spawn4 do
  def greet do
    receive do
      {sender, msg} ->
        send sender, { :ok, "Hello, #{msg}" }
        greet()
    end
  end
end


pid = spawn(Spawn4, :greet, [])

send pid, {self(), "World!"}
receive do
  {:ok, message} ->
    IO.puts message
end

send pid, {self(), "Kermit!"}
receive do
  {:ok, message} ->
    IO.puts message
  after 500 ->
    IO.puts "The greeter has gone away"
end

send pid, {self(), "elixir!"}
receive do
  {:ok, message} ->
    IO.puts message
  after 500 ->
    IO.puts "The greeter has gone away"
end
#greet()를 재귀를 이용하여 메시지를 처리하도록 하였다. -> 메시지를 추가하여도 계속 호출이 가능하다.

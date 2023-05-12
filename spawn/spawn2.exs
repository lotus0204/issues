defmodule Spawn2 do
  def greet do
    receive do
      {sender, msg} ->
        send sender, { :ok, "Hello, #{msg}" }
    end
  end
end


pid = spawn(Spawn2, :greet, [])

send pid, {self(), "World!"}
receive do
  {:ok, message} ->
    IO.puts message
end

send pid, {self(), "Kermit!"}
receive do
  {:ok, message} ->
    IO.puts message
end
#greet가 하나의 메시지만 처리할 수 있기 때문에 두번째 메시지가 출력되지 않는다.

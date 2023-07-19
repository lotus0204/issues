defmodule Sequence.Server do
  use GenServer # GenServer는 behavior이다.

  #생성자 역할을하는 코드
  def init(initial_number) do
    {:ok, initial_number}
  end

  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_cast({:increment_number, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  # def init(stack) do
  #   {:ok, stack}
  # end

  # def handle_call(:pop, _from, [head | tail]) do
  #   {:reply, head, tail}
  # end
end

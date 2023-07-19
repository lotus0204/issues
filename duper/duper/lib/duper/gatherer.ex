defmodule Duper.Gatherer do
  use GenServer

  @me Gatherer

  # api

  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done() do
    GenServer.cast(@me, :done)
  end

  def result(path, hash) do
    GenServer.cast(@me, { :result, path, hash })
  end

  # server
  # 수집서버가 실행된 후에 워커가 실행되어야 하기 때문에, 수집서버의 초기화 단계에서 워커를 생성해야 한다.
  def init(worker_count) do
    Process.send_after(self(), :kickoff, 0)
    { :ok, worker_count }
  end

  def handle_info(:kickoff, worker_count) do
    1..worker_count
    |> Enum.each(fn _ -> Duper.WorkerSupervisor.add_worker() end)
    { :noreply, worker_count }
  end

  # 워커 수가 1개이면 결과를 보고하고 프로그램 종료, 그렇지 않으면 워커수를 하나씩 줄인다.
  def handle_cast(:done, _worker_count = 1) do
    report_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    { :noreply, worker_count - 1 }
  end

  def handle_cast({:result, path, hash}, worker_count) do
    Duper.Results.add_hash_for(path, hash)
    { :noreply, worker_count }
  end

  defp report_results() do
    IO.puts "Results:\n"
    Duper.Results.find_duplicates()
    |> Enum.each(&IO.inspect/1)
  end
end

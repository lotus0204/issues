defmodule Duper.Worker do
  use GenServer, restart: :transient

  # 워커는 경로를 하나 요청하고, 파일의 해식를 계산해서 결과를 수집서버에 보낸다.
  # 결국은 탐색 요청과 그 결과를 해시값으로 변환하고, 결과를 수집서버에 보낸다.
  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end


  def init(:no_args) do
    # 0초 후에 자기 자신에게 :do_one_file 메시지를 보내라.
    Process.send_after(self(), :do_one_file, 0)
    { :ok, nil }
  end


  def handle_info(:do_one_file, _) do
    Duper.PathFinder.next_path() # 경로탐색 서버에 경로탐색을 요청
    |> add_result() # 경로 탐색서버로부터 받은 경로를 수집서버에 전달
  end

  #경로가 없는 경우
  defp add_result(nil) do
    Duper.Gatherer.done() # 결과가 없으면 수집서버에 done 메시지를 전달
    {:stop, :normal, nil} # {:stop, :normal, nil} 튜플을 반환하여 GenServer가 종료되도록
  end

  #경로가 있는 경우
  defp add_result(path) do
    Duper.Gatherer.result(path, hash_of_file_at(path)) # 수집서버에 경로와 해당 경로의 해시값을 전달
    send(self(), :do_one_file) # 새로운 :do_one_file 메시지를 보내 다음 파일을 처리하도록 예약
    { :noreply, nil } # {:noreply, nil} 튜플을 반환하여 메시지 처리가 끝나고도 GenServer가 동작을 계속할 수 있도록
  end

  #함수는 주어진 경로의 파일 해시를 계산
  defp hash_of_file_at(path) do
    File.stream!(path, [], 1024*1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn (block, hash) ->
        :crypto.hash_update(hash, block)
      end)
    |> :crypto.hash_final()
  end
end

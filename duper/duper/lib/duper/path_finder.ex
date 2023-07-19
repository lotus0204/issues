defmodule Duper.PathFinder do
  use GenServer

  @me PathFinder

  def start_link(root) do
    GenServer.start_link(__MODULE__, root, name: @me)
  end

  def next_path() do
    GenServer.call(@me, :next_path)
  end


  def init(path) do
    # 파일 시스템을 탐색하는 라이브러리
    DirWalker.start_link(path)
  end

  def handle_call(:next_path, _from, dir_walker) do
    path = case DirWalker.next(dir_walker) do
             [ path ] -> path # 경로가 하나인 리스트는 path에 할당
             other    -> other # 경로가 없거나 두 개 이상인 경우는 그대로 other에 할당
           end

    { :reply, path, dir_walker }
  end

end

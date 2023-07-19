defmodule Duper.Results do
  # 중복제거하여 저장하는 서버
  use GenServer

  @me __MODULE__


  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: @me)
  end

  def add_hash_for(path, hash) do
    GenServer.cast(@me, { :add, path, hash })
  end

  def find_duplicates() do
    GenServer.call(@me, :find_duplicates)
  end

  # Server

  def init(:no_args) do
    { :ok, %{} }
  end


  def handle_cast({ :add, path, hash }, results) do
    # results에서 hash를 찾아서 없으면 results에 hash:[path]의 형태로 넣고 있으면 [path | existing]를 넣는다.
    # Updates the key in map with the given function.

# If key is present in map then the existing value is passed to fun and its result is used as the updated value of key.
# If key is not present in map, default is inserted as the value of key.
# The default value will not be passed through the update function.

    results =
      Map.update(
        results,
        hash,
        [ path ],
        fn existing ->
          [ path | existing ]
        end)
    { :noreply, results }
  end

  def handle_call(:find_duplicates, _from, results) do
    {
      :reply,
      hashes_with_more_than_one_path(results),
      results
    }
  end

  defp hashes_with_more_than_one_path(results) do
    results
    |> Enum.filter(fn { _hash, paths } -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end

end

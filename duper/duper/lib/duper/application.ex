defmodule Duper.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
        Duper.Results,
      { Duper.PathFinder,       "/Users/Park/Downloads" },
        Duper.WorkerSupervisor,
      { Duper.Gatherer,         5 },
    ]
    # 34.61s user 14.39s system 96% cpu 50.919 total
    # 34.09s user 19.64s system 140% cpu 38.294 total
    # 34.10s user 28.35s system 314% cpu 19.853 total
    # 34.09s user 28.73s system 362% cpu 17.341 total

    #하나의 프로세스가 실패하면 전체가 실패한 것과 같기 때문에 one_for_all 전략을 사용한다.
    opts = [strategy: :one_for_all, name: Duper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

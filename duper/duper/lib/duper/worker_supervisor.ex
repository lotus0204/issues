defmodule Duper.WorkerSupervisor do
  # 때때로 관리 대상 자식 프로세스를 앱 시작시에는 모르는 상태일 수 있습니다. (예를 들면, 각 유저가 사이트에 접속하는걸 처리할 새로운 프로세스를 각각 만드는 웹 애플리케이션이 있습니다.)
  # 여기서는 한 종류의 서버를 관리하는 경우 라고 한다.
  # 다이나믹 슈퍼바이저라는 것을 명시
  use DynamicSupervisor

  @me WorkerSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end

  # 서버 내에서 자동으로 호출되어 초기화 된다.
  def init(:no_args) do
    # 전략을 설정. 다이나믹 슈퍼바이저의 경우 one_for_one만 사용할 수 있다. 자식 프로세스를 따로 지정하지 않기 때문에.
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # 내가 준 명세대로 하위 프로세스를 추가하라. Duper.Worker를 하위 프로세스로 추가하라.
  def add_worker() do
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Duper.Worker)
  end
end

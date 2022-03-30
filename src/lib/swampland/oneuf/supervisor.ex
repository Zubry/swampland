defmodule Swampland.OneUf.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Swampland.OneUf.Course.child_spec,
      Swampland.OneUf.Producer,
      Supervisor.child_spec(Swampland.OneUf.Consumer, id: :consumer_1),
      Supervisor.child_spec(Swampland.OneUf.Consumer, id: :consumer_2),
      Supervisor.child_spec(Swampland.OneUf.Consumer, id: :consumer_3),
      Supervisor.child_spec(Swampland.OneUf.Consumer, id: :consumer_4),
      Supervisor.child_spec(Swampland.OneUf.Consumer, id: :consumer_5),
      Supervisor.child_spec(Swampland.OneUf.Consumer, id: :consumer_6),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

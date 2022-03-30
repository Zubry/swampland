defmodule Swampland.OneUf.Consumer do
  use GenStage

  require Logger

  @min_demand 1
  @max_demand 2

  def start_link(opts) do
    GenStage.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:consumer, :the_state_does_not_matter, subscribe_to: [{Swampland.OneUf.Producer, min_demand: @min_demand, max_demand: @max_demand}]}
  end

  def handle_events(events, _from, state) do
    for {term, course} <- events do
      Swampland.OneUf.Course.create_course(course, term)
    end

    {:noreply, [], state}
  end
end

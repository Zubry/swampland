defmodule Swampland.OneUf.Producer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, %{ events: [], demand: 0, control_number: 0, term: nil }, []}
  end

  def watch_term(term) do
    GenStage.call(__MODULE__, {:watch_term, term})
  end

  def handle_call({:watch_term, term}, _from, state) do
    Process.send_after(self(), :dispatch, 0)
    {:reply, :ok, [], Map.put(state, :term, term)}
  end

  def handle_info(:dispatch, state) do
    dispatch_events(state)
  end

  def handle_demand(incoming_demand, %{ demand: demand } = state) do
    state
    |> Map.put(:demand, demand + incoming_demand)
    |> dispatch_events
  end

  defp dispatch_events(%{ events: events, demand: demand } = state) when length(events) >= demand do
    {outgoing, remaining} = Enum.split(events, demand)

    new_state = state
      |> Map.put(:demand, 0)
      |> Map.put(:events, remaining)

    {:noreply, outgoing, new_state}
  end

  defp dispatch_events(%{ term: nil } = state) do
    {:noreply, [], state}
  end

  defp dispatch_events(%{ events: events, demand: demand, control_number: control_number } = state) when length(events) < demand do
    case Swampland.OneUf.Course.get_courses("2188", control_number) do
      {:ok, next_control_number, courses} ->
        dispatch_events(%{
          events: events ++ Enum.map(courses, fn course -> {"2188", course} end),
          demand: demand,
          control_number: next_control_number
        })
      _ ->
        dispatch_events(state)
    end
  end
end

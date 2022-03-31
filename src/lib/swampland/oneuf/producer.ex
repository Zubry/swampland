defmodule Swampland.OneUf.Producer do
  require Logger
  use GenStage

  defstruct events: [], demand: 0, control_number: 0, term: nil

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, %__MODULE__{}, []}
  end

  def watch_term(term) do
    GenStage.call(__MODULE__, {:watch_term, term})
  end

  def handle_call({:watch_term, nil}, _from, state) do
    {:reply, :ok, [], %{state | term: nil}}
  end

  def handle_call({:watch_term, term}, _from, state) do
    Process.send_after(self(), :dispatch, 0)

    term = Swampland.Terms.get_term_by_code(term)

    {:reply, :ok, [], %{state | term: term}}
  end

  def handle_info(:dispatch, state) do
    dispatch_events(state)
  end

  def handle_demand(incoming_demand, %{demand: demand} = state) do
    # When demand exceeds the number of events, queue up the demand and load more items from the API
    dispatch_events(%{state | demand: demand + incoming_demand})
  end

  defp dispatch_events(%{events: events, demand: demand} = state) when length(events) >= demand do
    # If we have enough events to cover the incoming demand, just send out the requested events
    {outgoing, remaining} = Enum.split(events, demand)

    {:noreply, outgoing, %{state | demand: 0, events: remaining}}
  end

  defp dispatch_events(%{term: nil} = state) do
    {:noreply, [], state}
  end

  defp dispatch_events(
         %{events: events, demand: demand, control_number: control_number, term: term} = state
       )
       when length(events) < demand do
    case Swampland.OneUf.Course.get_courses(term.code, control_number) do
      # When the API comes back with the next control number as 0, it means that we reached the end
      # and need to unset the watched term to stop hammering the API
      {:ok, 0, courses} ->
        Logger.debug "Finished loading #{term.semester} #{term.year}"

        dispatch_events(%{
          state
          | events: events ++ Enum.map(courses, fn course -> {term, course} end),
            control_number: 0,
            term: nil
        })

      # Under normal circumstances, the API returns a new control number, which is basically the next id to request
      # So set that as our control number for the next iteration
      {:ok, next_control_number, courses} ->
        dispatch_events(%{
          state
          | events: events ++ Enum.map(courses, fn course -> {term, course} end),
            control_number: next_control_number
        })

      _ ->
        dispatch_events(state)
    end
  end
end

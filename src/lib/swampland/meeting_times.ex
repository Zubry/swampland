defmodule Swampland.MeetingTimes do
  @moduledoc """
  The MeetingTimes context.
  """

  import Ecto.Query, warn: false
  alias Swampland.Repo

  alias Swampland.MeetingTimes.MeetingTime

  @doc """
  Returns the list of meeting_times.

  ## Examples

      iex> list_meeting_times()
      [%MeetingTime{}, ...]

  """
  def list_meeting_times do
    Repo.all(MeetingTime)
  end

  @doc """
  Gets a single meeting_time.

  Raises `Ecto.NoResultsError` if the Meeting time does not exist.

  ## Examples

      iex> get_meeting_time!(123)
      %MeetingTime{}

      iex> get_meeting_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting_time!(id), do: Repo.get!(MeetingTime, id)

  @doc """
  Creates a meeting_time.

  ## Examples

      iex> create_meeting_time(%{field: value})
      {:ok, %MeetingTime{}}

      iex> create_meeting_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting_time(attrs \\ %{}) do
    %MeetingTime{}
    |> MeetingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meeting_time.

  ## Examples

      iex> update_meeting_time(meeting_time, %{field: new_value})
      {:ok, %MeetingTime{}}

      iex> update_meeting_time(meeting_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting_time(%MeetingTime{} = meeting_time, attrs) do
    meeting_time
    |> MeetingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting_time.

  ## Examples

      iex> delete_meeting_time(meeting_time)
      {:ok, %MeetingTime{}}

      iex> delete_meeting_time(meeting_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting_time(%MeetingTime{} = meeting_time) do
    Repo.delete(meeting_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting_time changes.

  ## Examples

      iex> change_meeting_time(meeting_time)
      %Ecto.Changeset{data: %MeetingTime{}}

  """
  def change_meeting_time(%MeetingTime{} = meeting_time, attrs \\ %{}) do
    MeetingTime.changeset(meeting_time, attrs)
  end
end

defmodule Swampland.MeetingTimes.MeetingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meeting_times" do
    field :beginning, :string
    field :building, :string
    field :day, :string
    field :end, :string
    field :room, :string

    belongs_to :section, Swampland.Sections.Section

    timestamps()
  end

  @doc false
  def changeset(meeting_time, attrs) do
    meeting_time
    |> cast(attrs, [:day, :beginning, :end, :building, :room])
    |> validate_required([:day, :beginning, :end, :building, :room])
  end
end

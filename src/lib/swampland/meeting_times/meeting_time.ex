defmodule Swampland.MeetingTimes.MeetingTime do
  use Ecto.Schema

  embedded_schema do
    field :beginning, :string
    field :building, :string
    field :day, :string
    field :end, :string
    field :room, :string
  end
end

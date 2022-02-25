defmodule Swampland.Sections.Section do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sections" do
    field :acad_career, :string
    field :class_number, :integer
    field :credits, :integer
    field :dept_name, :string
    field :display, :string
    field :grad_basis, :string
    field :number, :string
    field :instructor_id, :id
    field :meeting_times, :id

    has_many :instructors, Instructors
    has_many :meeting_times, MeetingTimes
    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:number, :class_number, :grad_basis, :acad_career, :display, :credits, :dept_name])
    |> validate_required([:number, :class_number, :grad_basis, :acad_career, :display, :credits, :dept_name])
  end
end

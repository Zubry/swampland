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

    many_to_many :instructors, Swampland.Instructors.Instructor, join_through: "section_instructors"
    many_to_many :meeting_times, Swampland.MeetingTimes.MeetingTime, join_through: "section_meeting_times"

    belongs_to :course, Swampland.Courses.Course

    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:number, :class_number, :grad_basis, :acad_career, :display, :credits, :dept_name])
    |> validate_required([:number, :class_number, :grad_basis, :acad_career, :display, :credits, :dept_name])
  end
end

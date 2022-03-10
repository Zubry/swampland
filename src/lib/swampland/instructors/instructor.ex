defmodule Swampland.Instructors.Instructor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructors" do
    field :name, :string

    many_to_many :section, Swampland.Sections.Section, join_through: "section_instructors"

    timestamps()
  end

  @doc false
  def changeset(instructor, attrs) do
    instructor
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

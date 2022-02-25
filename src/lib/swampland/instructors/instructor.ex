defmodule Swampland.Instructors.Instructor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructors" do
    field :name, :string

    belongs_to :section, Swampland.Sections.Section

    timestamps()
  end

  @doc false
  def changeset(instructor, attrs) do
    instructor
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

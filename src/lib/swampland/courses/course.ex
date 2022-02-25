defmodule Swampland.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :code, :string
    field :course_id, :string
    field :description, :string
    field :name, :string
    field :prerequisites, :string

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:code, :course_id, :name, :description, :prerequisites])
    |> validate_required([:code, :course_id, :name, :description, :prerequisites])
  end
end

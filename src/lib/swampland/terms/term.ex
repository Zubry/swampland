defmodule Swampland.Terms.Term do
  use Ecto.Schema
  import Ecto.Changeset

  schema "terms" do
    field :active, :boolean, default: false
    field :code, :string
    field :semester, :string
    field :year, :string

    has_many :courses, Swampland.Courses.Course

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:code, :active])
    |> validate_required([:code, :active])
  end
end

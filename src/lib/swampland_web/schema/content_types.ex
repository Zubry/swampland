defmodule SwamplandWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  alias SwamplandWeb.Resolvers

  object :term do
    field :id, non_null(:id)
    field :active, :boolean
    field :code, :string
    field :semester, :string
    field :year, :string
    field :courses, list_of(:course) do
      resolve &Resolvers.Courses.list_courses/3
    end
  end

  object :course do
    field :id, non_null(:id)
    field :code, :string
    field :course_id, :string
    field :description, :string
    field :name, :string
    field :prerequisites, :string
    field :sections, list_of(:section) do
      resolve &Resolvers.Sections.list_sections/3
    end
  end

  object :section do
    field :id, non_null(:id)
    field :acad_career, :string
    field :class_number, :integer
    field :credits, :integer
    field :dept_name, :string
    field :display, :string
    field :grad_basis, :string
    field :number, :string
    field :instructors, list_of(:instructor) do
      resolve &Resolvers.Instructors.list_instructors/3
    end
  end

  object :instructor do
    field :id, non_null(:id)
    field :name, :string
  end

  object :meeting_time do
    field :beginning, :string
    field :building, :string
    field :day, :string
    field :end, :string
    field :room, :string
  end
end

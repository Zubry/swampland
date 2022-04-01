defmodule SwamplandWeb.Schema do
  use Absinthe.Schema
  import_types SwamplandWeb.Schema.ContentTypes

  alias SwamplandWeb.Resolvers

  query do
    @desc "Get all terms"
    field :terms, list_of(:term) do
      resolve &Resolvers.Terms.list_terms/3
    end

    @desc "Get all courses"
    field :courses, list_of(:course) do
      resolve &Resolvers.Courses.list_courses/3
    end

    @desc "Get all sections"
    field :sections, list_of(:section) do
      resolve &Resolvers.Sections.list_sections/3
    end

    @desc "Get all instructors"
    field :instructors, list_of(:instructor) do
      resolve &Resolvers.Instructors.list_instructors/3
    end
  end
end

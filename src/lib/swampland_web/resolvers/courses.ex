defmodule SwamplandWeb.Resolvers.Courses do
  alias Swampland.Courses

  def list_courses(_parent, _args, _resolution) do
    {:ok, Courses.list_courses()}
  end

  def get_course(_parent, %{ id: id }, _resolution) do
    {:ok, Courses.get_course!(id)}
  end
end

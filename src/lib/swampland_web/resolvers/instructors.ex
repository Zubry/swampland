defmodule SwamplandWeb.Resolvers.Instructors do
  alias Swampland.Instructors

  def list_instructors(_parent, _args, _resolution) do
    {:ok, Instructors.list_instructors()}
  end
end

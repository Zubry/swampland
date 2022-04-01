defmodule SwamplandWeb.Resolvers.Sections do
  alias Swampland.Sections

  def list_sections(_parent, _args, _resolution) do
    {:ok, Sections.list_sections()}
  end
end

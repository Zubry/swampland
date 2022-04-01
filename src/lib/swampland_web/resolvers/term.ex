defmodule SwamplandWeb.Resolvers.Terms do
  alias Swampland.Terms

  def list_terms(_parent, _args, _resolution) do
    {:ok, Terms.list_terms()}
  end
end

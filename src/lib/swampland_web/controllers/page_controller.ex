defmodule SwamplandWeb.PageController do
  use SwamplandWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

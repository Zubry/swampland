defmodule SwamplandWeb.SectionController do
  use SwamplandWeb, :controller

  alias Swampland.Sections
  alias Swampland.Sections.Section

  action_fallback SwamplandWeb.FallbackController

  def index(conn, _params) do
    sections = Sections.list_sections()
    render(conn, "index.json", sections: sections)
  end

  def create(conn, %{"section" => section_params}) do
    with {:ok, %Section{} = section} <- Sections.create_section(section_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.section_path(conn, :show, section))
      |> render("show.json", section: section)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Sections.get_section!(id)
    render(conn, "show.json", section: section)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Sections.get_section!(id)

    with {:ok, %Section{} = section} <- Sections.update_section(section, section_params) do
      render(conn, "show.json", section: section)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Sections.get_section!(id)

    with {:ok, %Section{}} <- Sections.delete_section(section) do
      send_resp(conn, :no_content, "")
    end
  end
end

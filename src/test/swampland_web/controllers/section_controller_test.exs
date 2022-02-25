defmodule SwamplandWeb.SectionControllerTest do
  use SwamplandWeb.ConnCase

  alias Swampland.Sections
  alias Swampland.Sections.Section

  @create_attrs %{
    acad_career: "some acad_career",
    class_number: 42,
    credits: 42,
    dept_name: "some dept_name",
    display: "some display",
    grad_basis: "some grad_basis",
    number: "some number"
  }
  @update_attrs %{
    acad_career: "some updated acad_career",
    class_number: 43,
    credits: 43,
    dept_name: "some updated dept_name",
    display: "some updated display",
    grad_basis: "some updated grad_basis",
    number: "some updated number"
  }
  @invalid_attrs %{acad_career: nil, class_number: nil, credits: nil, dept_name: nil, display: nil, grad_basis: nil, number: nil}

  def fixture(:section) do
    {:ok, section} = Sections.create_section(@create_attrs)
    section
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sections", %{conn: conn} do
      conn = get(conn, Routes.section_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create section" do
    test "renders section when data is valid", %{conn: conn} do
      conn = post(conn, Routes.section_path(conn, :create), section: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.section_path(conn, :show, id))

      assert %{
               "id" => id,
               "acad_career" => "some acad_career",
               "class_number" => 42,
               "credits" => 42,
               "dept_name" => "some dept_name",
               "display" => "some display",
               "grad_basis" => "some grad_basis",
               "number" => "some number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.section_path(conn, :create), section: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update section" do
    setup [:create_section]

    test "renders section when data is valid", %{conn: conn, section: %Section{id: id} = section} do
      conn = put(conn, Routes.section_path(conn, :update, section), section: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.section_path(conn, :show, id))

      assert %{
               "id" => id,
               "acad_career" => "some updated acad_career",
               "class_number" => 43,
               "credits" => 43,
               "dept_name" => "some updated dept_name",
               "display" => "some updated display",
               "grad_basis" => "some updated grad_basis",
               "number" => "some updated number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, section: section} do
      conn = put(conn, Routes.section_path(conn, :update, section), section: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete section" do
    setup [:create_section]

    test "deletes chosen section", %{conn: conn, section: section} do
      conn = delete(conn, Routes.section_path(conn, :delete, section))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.section_path(conn, :show, section))
      end
    end
  end

  defp create_section(_) do
    section = fixture(:section)
    %{section: section}
  end
end

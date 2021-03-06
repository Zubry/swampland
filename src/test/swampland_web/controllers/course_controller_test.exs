defmodule SwamplandWeb.CourseControllerTest do
  use SwamplandWeb.ConnCase

  alias Swampland.Courses
  alias Swampland.Courses.Course

  @create_attrs %{
    code: "some code",
    course_id: "some course_id",
    description: "some description",
    name: "some name",
    prerequisites: "some prerequisites"
  }
  @update_attrs %{
    code: "some updated code",
    course_id: "some updated course_id",
    description: "some updated description",
    name: "some updated name",
    prerequisites: "some updated prerequisites"
  }
  @invalid_attrs %{code: nil, course_id: nil, description: nil, name: nil, prerequisites: nil}

  def fixture(:course) do
    {:ok, course} = Courses.create_course(@create_attrs)
    course
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all courses", %{conn: conn} do
      conn = get(conn, Routes.course_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create course" do
    test "renders course when data is valid", %{conn: conn} do
      conn = post(conn, Routes.course_path(conn, :create), course: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.course_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some code",
               "course_id" => "some course_id",
               "description" => "some description",
               "name" => "some name",
               "prerequisites" => "some prerequisites"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.course_path(conn, :create), course: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update course" do
    setup [:create_course]

    test "renders course when data is valid", %{conn: conn, course: %Course{id: id} = course} do
      conn = put(conn, Routes.course_path(conn, :update, course), course: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.course_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some updated code",
               "course_id" => "some updated course_id",
               "description" => "some updated description",
               "name" => "some updated name",
               "prerequisites" => "some updated prerequisites"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, course: course} do
      conn = put(conn, Routes.course_path(conn, :update, course), course: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete course" do
    setup [:create_course]

    test "deletes chosen course", %{conn: conn, course: course} do
      conn = delete(conn, Routes.course_path(conn, :delete, course))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.course_path(conn, :show, course))
      end
    end
  end

  defp create_course(_) do
    course = fixture(:course)
    %{course: course}
  end
end

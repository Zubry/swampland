defmodule Swampland.CoursesTest do
  use Swampland.DataCase

  alias Swampland.Courses

  describe "courses" do
    alias Swampland.Courses.Course

    @valid_attrs %{code: "some code", course_id: "some course_id", description: "some description", name: "some name", prerequisites: "some prerequisites"}
    @update_attrs %{code: "some updated code", course_id: "some updated course_id", description: "some updated description", name: "some updated name", prerequisites: "some updated prerequisites"}
    @invalid_attrs %{code: nil, course_id: nil, description: nil, name: nil, prerequisites: nil}

    def course_fixture(attrs \\ %{}) do
      {:ok, course} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Courses.create_course()

      course
    end

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      assert {:ok, %Course{} = course} = Courses.create_course(@valid_attrs)
      assert course.code == "some code"
      assert course.course_id == "some course_id"
      assert course.description == "some description"
      assert course.name == "some name"
      assert course.prerequisites == "some prerequisites"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      assert {:ok, %Course{} = course} = Courses.update_course(course, @update_attrs)
      assert course.code == "some updated code"
      assert course.course_id == "some updated course_id"
      assert course.description == "some updated description"
      assert course.name == "some updated name"
      assert course.prerequisites == "some updated prerequisites"
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_course(course, @invalid_attrs)
      assert course == Courses.get_course!(course.id)
    end

    test "delete_course/1 deletes the course" do
      course = course_fixture()
      assert {:ok, %Course{}} = Courses.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = course_fixture()
      assert %Ecto.Changeset{} = Courses.change_course(course)
    end
  end
end

defmodule Swampland.InstructorsTest do
  use Swampland.DataCase

  alias Swampland.Instructors

  describe "instructors" do
    alias Swampland.Instructors.Instructor

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def instructor_fixture(attrs \\ %{}) do
      {:ok, instructor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Instructors.create_instructor()

      instructor
    end

    test "list_instructors/0 returns all instructors" do
      instructor = instructor_fixture()
      assert Instructors.list_instructors() == [instructor]
    end

    test "get_instructor!/1 returns the instructor with given id" do
      instructor = instructor_fixture()
      assert Instructors.get_instructor!(instructor.id) == instructor
    end

    test "create_instructor/1 with valid data creates a instructor" do
      assert {:ok, %Instructor{} = instructor} = Instructors.create_instructor(@valid_attrs)
      assert instructor.name == "some name"
    end

    test "create_instructor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Instructors.create_instructor(@invalid_attrs)
    end

    test "update_instructor/2 with valid data updates the instructor" do
      instructor = instructor_fixture()
      assert {:ok, %Instructor{} = instructor} = Instructors.update_instructor(instructor, @update_attrs)
      assert instructor.name == "some updated name"
    end

    test "update_instructor/2 with invalid data returns error changeset" do
      instructor = instructor_fixture()
      assert {:error, %Ecto.Changeset{}} = Instructors.update_instructor(instructor, @invalid_attrs)
      assert instructor == Instructors.get_instructor!(instructor.id)
    end

    test "delete_instructor/1 deletes the instructor" do
      instructor = instructor_fixture()
      assert {:ok, %Instructor{}} = Instructors.delete_instructor(instructor)
      assert_raise Ecto.NoResultsError, fn -> Instructors.get_instructor!(instructor.id) end
    end

    test "change_instructor/1 returns a instructor changeset" do
      instructor = instructor_fixture()
      assert %Ecto.Changeset{} = Instructors.change_instructor(instructor)
    end
  end
end

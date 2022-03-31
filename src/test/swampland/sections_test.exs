defmodule Swampland.SectionsTest do
  use Swampland.DataCase

  alias Swampland.Sections

  describe "sections" do
    alias Swampland.Sections.Section

    @valid_attrs %{
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
    @invalid_attrs %{
      acad_career: nil,
      class_number: nil,
      credits: nil,
      dept_name: nil,
      display: nil,
      grad_basis: nil,
      number: nil
    }

    def section_fixture(attrs \\ %{}) do
      {:ok, section} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sections.create_section()

      section
    end

    test "list_sections/0 returns all sections" do
      section = section_fixture()
      assert Sections.list_sections() == [section]
    end

    test "get_section!/1 returns the section with given id" do
      section = section_fixture()
      assert Sections.get_section!(section.id) == section
    end

    test "create_section/1 with valid data creates a section" do
      assert {:ok, %Section{} = section} = Sections.create_section(@valid_attrs)
      assert section.acad_career == "some acad_career"
      assert section.class_number == 42
      assert section.credits == 42
      assert section.dept_name == "some dept_name"
      assert section.display == "some display"
      assert section.grad_basis == "some grad_basis"
      assert section.number == "some number"
    end

    test "create_section/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sections.create_section(@invalid_attrs)
    end

    test "update_section/2 with valid data updates the section" do
      section = section_fixture()
      assert {:ok, %Section{} = section} = Sections.update_section(section, @update_attrs)
      assert section.acad_career == "some updated acad_career"
      assert section.class_number == 43
      assert section.credits == 43
      assert section.dept_name == "some updated dept_name"
      assert section.display == "some updated display"
      assert section.grad_basis == "some updated grad_basis"
      assert section.number == "some updated number"
    end

    test "update_section/2 with invalid data returns error changeset" do
      section = section_fixture()
      assert {:error, %Ecto.Changeset{}} = Sections.update_section(section, @invalid_attrs)
      assert section == Sections.get_section!(section.id)
    end

    test "delete_section/1 deletes the section" do
      section = section_fixture()
      assert {:ok, %Section{}} = Sections.delete_section(section)
      assert_raise Ecto.NoResultsError, fn -> Sections.get_section!(section.id) end
    end

    test "change_section/1 returns a section changeset" do
      section = section_fixture()
      assert %Ecto.Changeset{} = Sections.change_section(section)
    end
  end
end

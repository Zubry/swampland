defmodule Swampland.TermsTest do
  use Swampland.DataCase

  alias Swampland.Terms

  describe "terms" do
    alias Swampland.Terms.Term

    @valid_attrs %{active: true, code: "some code"}
    @update_attrs %{active: false, code: "some updated code"}
    @invalid_attrs %{active: nil, code: nil}

    def term_fixture(attrs \\ %{}) do
      {:ok, term} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Terms.create_term()

      term
    end

    test "list_terms/0 returns all terms" do
      term = term_fixture()
      assert Terms.list_terms() == [term]
    end

    test "get_term!/1 returns the term with given id" do
      term = term_fixture()
      assert Terms.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term" do
      assert {:ok, %Term{} = term} = Terms.create_term(@valid_attrs)
      assert term.active == true
      assert term.code == "some code"
    end

    test "create_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Terms.create_term(@invalid_attrs)
    end

    test "update_term/2 with valid data updates the term" do
      term = term_fixture()
      assert {:ok, %Term{} = term} = Terms.update_term(term, @update_attrs)
      assert term.active == false
      assert term.code == "some updated code"
    end

    test "update_term/2 with invalid data returns error changeset" do
      term = term_fixture()
      assert {:error, %Ecto.Changeset{}} = Terms.update_term(term, @invalid_attrs)
      assert term == Terms.get_term!(term.id)
    end

    test "delete_term/1 deletes the term" do
      term = term_fixture()
      assert {:ok, %Term{}} = Terms.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> Terms.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset" do
      term = term_fixture()
      assert %Ecto.Changeset{} = Terms.change_term(term)
    end
  end
end

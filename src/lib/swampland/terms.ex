defmodule Swampland.Terms do
  @moduledoc """
  The Terms context.
  """

  import Ecto.Query, warn: false
  alias Swampland.Repo

  alias Swampland.Terms.Term

  @doc """
  Returns the list of terms.

  ## Examples

      iex> list_terms()
      [%Term{}, ...]

  """
  def list_terms do
    Repo.all(Term)
  end

  def list_active_terms() do
    Repo.all(from t in Term, where: t.active == true)
  end

  def set_active(code) do
    from(t in Term, where: t.code == ^code)
    |> Repo.update_all(set: [active: true])
  end

  def set_inactive(code) do
    from(t in Term, where: t.code == ^code)
    |> Repo.update_all(set: [active: false])
  end

  def get_term_by_code(code) do
    Repo.one(from t in Term, where: t.code == ^code)
  end

  @doc """
  Gets a single term.

  Raises `Ecto.NoResultsError` if the Term does not exist.

  ## Examples

      iex> get_term!(123)
      %Term{}

      iex> get_term!(456)
      ** (Ecto.NoResultsError)

  """
  def get_term!(id), do: Repo.get!(Term, id)

  @doc """
  Creates a term.

  ## Examples

      iex> create_term(%{field: value})
      {:ok, %Term{}}

      iex> create_term(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a term.

  ## Examples

      iex> update_term(term, %{field: new_value})
      {:ok, %Term{}}

      iex> update_term(term, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_term(%Term{} = term, attrs) do
    term
    |> Term.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a term.

  ## Examples

      iex> delete_term(term)
      {:ok, %Term{}}

      iex> delete_term(term)
      {:error, %Ecto.Changeset{}}

  """
  def delete_term(%Term{} = term) do
    Repo.delete(term)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking term changes.

  ## Examples

      iex> change_term(term)
      %Ecto.Changeset{data: %Term{}}

  """
  def change_term(%Term{} = term, attrs \\ %{}) do
    Term.changeset(term, attrs)
  end
end

defmodule Swampland.Repo.Migrations.CreateTerms do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :code, :string
      add :semester, :string
      add :year, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end

    alter table(:courses) do
      add :term_id, references(:terms)
    end
  end
end

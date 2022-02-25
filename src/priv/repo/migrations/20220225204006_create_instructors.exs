defmodule Swampland.Repo.Migrations.CreateInstructors do
  use Ecto.Migration

  def change do
    create table(:instructors) do
      add :name, :string

      timestamps()
    end

  end
end

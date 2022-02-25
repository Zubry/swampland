defmodule Swampland.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :code, :string
      add :course_id, :string
      add :name, :string
      add :description, :string
      add :prerequisites, :string

      timestamps()
    end

  end
end

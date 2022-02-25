defmodule Swampland.Repo.Migrations.CourseContent do
  use Ecto.Migration

  def change do
    alter table(:courses) do
      modify :description, :text
      modify :prerequisites, :text
    end
  end
end

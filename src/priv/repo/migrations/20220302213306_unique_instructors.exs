defmodule Swampland.Repo.Migrations.UniqueInstructors do
  use Ecto.Migration

  def change do
    create unique_index(:instructors, [:name])
  end
end

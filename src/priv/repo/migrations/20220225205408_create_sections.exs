defmodule Swampland.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :number, :string
      add :class_number, :integer
      add :grad_basis, :string
      add :acad_career, :string
      add :display, :string
      add :credits, :integer
      add :dept_name, :string
      add :instructor_id, references(:instructors, on_delete: :nothing)
      add :meeting_times, references(:meeting_times, on_delete: :nothing)

      timestamps()
    end

    create index(:sections, [:instructor_id])
    create index(:sections, [:meeting_times])
  end
end

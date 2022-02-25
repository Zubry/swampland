defmodule Swampland.Repo.Migrations.SectionAssocs do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :course_id, references(:courses)
      remove :instructor_id
      remove :meeting_times
    end

    alter table(:instructors) do
      add :section_id, references(:sections)
    end

    alter table(:meeting_times) do
      add :section_id, references(:sections)
    end
  end
end

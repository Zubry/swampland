defmodule Swampland.Repo.Migrations.Manytomany do
  use Ecto.Migration

  def change do
    create table(:section_instructors) do
      add :section_id, references(:sections)
      add :instructor_id, references(:instructors)
    end

    create table(:section_meeting_times) do
      add :section_id, references(:sections)
      add :meeting_time_id, references(:meeting_times)
    end

    alter table(:instructors) do
      remove :section_id
    end

    alter table(:meeting_times) do
      remove :section_id
    end
  end
end

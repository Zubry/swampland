defmodule Swampland.Repo.Migrations.CreateMeetingTimes do
  use Ecto.Migration

  def change do
    create table(:meeting_times) do
      add :day, :string
      add :beginning, :string
      add :end, :string
      add :building, :string
      add :room, :string

      timestamps()
    end
  end
end

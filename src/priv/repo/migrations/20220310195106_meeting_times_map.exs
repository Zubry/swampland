defmodule Swampland.Repo.Migrations.MeetingTimesMap do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :meeting_times, {:array, :map}, default: []
    end
  end
end

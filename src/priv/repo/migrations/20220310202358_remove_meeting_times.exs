defmodule Swampland.Repo.Migrations.RemoveMeetingTimes do
  use Ecto.Migration

  def change do
    drop table "section_meeting_times"
    drop table "meeting_times"
  end
end

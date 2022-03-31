defmodule Swampland.MeetingTimesTest do
  use Swampland.DataCase

  alias Swampland.MeetingTimes

  describe "meeting_times" do
    alias Swampland.MeetingTimes.MeetingTime

    @valid_attrs %{
      beginning: "some beginning",
      building: "some building",
      day: "some day",
      end: "some end",
      room: "some room"
    }
    @update_attrs %{
      beginning: "some updated beginning",
      building: "some updated building",
      day: "some updated day",
      end: "some updated end",
      room: "some updated room"
    }
    @invalid_attrs %{beginning: nil, building: nil, day: nil, end: nil, room: nil}

    def meeting_time_fixture(attrs \\ %{}) do
      {:ok, meeting_time} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MeetingTimes.create_meeting_time()

      meeting_time
    end

    test "list_meeting_times/0 returns all meeting_times" do
      meeting_time = meeting_time_fixture()
      assert MeetingTimes.list_meeting_times() == [meeting_time]
    end

    test "get_meeting_time!/1 returns the meeting_time with given id" do
      meeting_time = meeting_time_fixture()
      assert MeetingTimes.get_meeting_time!(meeting_time.id) == meeting_time
    end

    test "create_meeting_time/1 with valid data creates a meeting_time" do
      assert {:ok, %MeetingTime{} = meeting_time} = MeetingTimes.create_meeting_time(@valid_attrs)
      assert meeting_time.beginning == "some beginning"
      assert meeting_time.building == "some building"
      assert meeting_time.day == "some day"
      assert meeting_time.end == "some end"
      assert meeting_time.room == "some room"
    end

    test "create_meeting_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MeetingTimes.create_meeting_time(@invalid_attrs)
    end

    test "update_meeting_time/2 with valid data updates the meeting_time" do
      meeting_time = meeting_time_fixture()

      assert {:ok, %MeetingTime{} = meeting_time} =
               MeetingTimes.update_meeting_time(meeting_time, @update_attrs)

      assert meeting_time.beginning == "some updated beginning"
      assert meeting_time.building == "some updated building"
      assert meeting_time.day == "some updated day"
      assert meeting_time.end == "some updated end"
      assert meeting_time.room == "some updated room"
    end

    test "update_meeting_time/2 with invalid data returns error changeset" do
      meeting_time = meeting_time_fixture()

      assert {:error, %Ecto.Changeset{}} =
               MeetingTimes.update_meeting_time(meeting_time, @invalid_attrs)

      assert meeting_time == MeetingTimes.get_meeting_time!(meeting_time.id)
    end

    test "delete_meeting_time/1 deletes the meeting_time" do
      meeting_time = meeting_time_fixture()
      assert {:ok, %MeetingTime{}} = MeetingTimes.delete_meeting_time(meeting_time)
      assert_raise Ecto.NoResultsError, fn -> MeetingTimes.get_meeting_time!(meeting_time.id) end
    end

    test "change_meeting_time/1 returns a meeting_time changeset" do
      meeting_time = meeting_time_fixture()
      assert %Ecto.Changeset{} = MeetingTimes.change_meeting_time(meeting_time)
    end
  end
end

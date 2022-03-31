defmodule Swampland.OneUf.Course do
  @moduledoc """
  The ONE.UF context
  """
  @timeout 2 * 60 * 1000

  import Ecto.Query

  alias Finch.Response
  alias Swampland.Repo
  alias Swampland.Instructors.Instructor

  require Logger

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       "https://one.uf.edu/" => [size: pool_size()]
     }}
  end

  def pool_size, do: 25

  def get_courses(term, control_number) do
    with uri <-
           "https://one.uf.edu/apix/soc/schedule/?category=CWSP&term=#{term}&last-control-number=#{control_number}",
         _ <- Logger.debug("Requesting #{uri}"),
         request <- Finch.build(:get, uri),
         {:ok, %Response{status: 200, body: body}} <-
           Finch.request(request, __MODULE__, receive_timeout: @timeout),
         [%{"COURSES" => courses, "LASTCONTROLNUMBER" => next_control_number}] <-
           Jason.decode!(body) do
      {:ok, next_control_number, courses}
    end
  end

  def get_course(course, term) do
    %Swampland.Courses.Course{
      term: term,
      code: course["code"],
      course_id: course["courseId"],
      description: course["description"],
      prerequisites: course["prerequisites"],
      name: course["name"],
      sections:
        for section <- course["sections"] do
          %Swampland.Sections.Section{
            acad_career: section["acadCareer"],
            class_number: section["classNumber"],
            credits: if(section["credits"] == "VAR", do: -1, else: section["credits"]),
            dept_name: section["deptName"],
            display: section["display"],
            grad_basis: section["gradBasis"],
            number: "#{section["number"]}",
            instructors:
              for instructor <- section["instructors"] do
                instructor["name"]
              end,
            meeting_times:
              for meet_time <- section["meetTimes"] do
                %Swampland.MeetingTimes.MeetingTime{
                  beginning: meet_time["meetTimeBegin"],
                  end: meet_time["meetTimeEnd"],
                  building: meet_time["meetBuilding"],
                  day: meet_time["meetDays"] |> Enum.join("|"),
                  room: meet_time["meetRoom"]
                }
              end
          }
        end
    }
  end

  def create_course(course, term) do
    Logger.debug("Creating #{course["code"]}")
    course = get_course(course, term)

    {sections, course} = Map.pop(course, :sections)

    course = Repo.insert!(Map.put(course, :sections, []))

    for section <- sections do
      {instructors, section} = Map.pop(section, :instructors)

      section = Ecto.build_assoc(course, :sections, Map.put(section, :instructors, []))

      section = Repo.insert!(section)

      Ecto.Changeset.change(section)
      |> Ecto.Changeset.put_assoc(:instructors, insert_and_get_all_instructors(instructors))
      |> Repo.update!()
    end

    {:ok, course}
  end

  defp insert_and_get_all_instructors([]) do
    []
  end

  defp insert_and_get_all_instructors(instructors) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    placeholders = %{timestamp: timestamp}

    maps =
      for instructor <- instructors do
        %{
          name: instructor,
          inserted_at: {:placeholder, :timestamp},
          updated_at: {:placeholder, :timestamp}
        }
      end

    Repo.insert_all(Instructor, maps, placeholders: placeholders, on_conflict: :nothing)

    Repo.all(from i in Instructor, where: i.name in ^instructors)
  end

  # Swampland.OneUf.create_course("cop3503", "2188")
  # Swampland.Courses.get_course!(2) |> Swampland.Repo.preload([sections: [:instructors]])
end

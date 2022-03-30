defmodule Swampland.OneUf.Course do
  @moduledoc """
  The ONE.UF context
  """
  import Ecto.Query

  alias Finch.Response
  alias Swampland.Repo
  alias Ecto.Multi
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
    Logger.debug "Requesting https://one.uf.edu/apix/soc/schedule/?category=CWSP&term=#{term}&last-control-number=#{control_number}"

    with request <- Finch.build(:get, "https://one.uf.edu/apix/soc/schedule/?category=CWSP&term=#{term}&last-control-number=#{control_number}"),
         {:ok, %Response{ status: 200, body: body }} <- Finch.request(request, __MODULE__, receive_timeout: 120_000),
         [%{ "COURSES" => courses, "LASTCONTROLNUMBER" => next_control_number }] <- Jason.decode!(body) do
          if next_control_number == 0 do
            Swampland.OneUf.watch_term(nil)
          end
          {:ok, next_control_number, courses}
    else
      err ->
        IO.inspect(err)
        {:error, err}
    end
  end

  def get_course(course, _term) do
    {:ok, %Swampland.Courses.Course{
      code: course["code"],
      course_id: course["courseId"],
      description: course["description"],
      prerequisites: course["prerequisites"],
      name: course["name"],
      sections: for section <- course["sections"] do
        %Swampland.Sections.Section{
          acad_career: section["acadCareer"],
          class_number: section["classNumber"],
          credits: (if section["credits"] == "VAR", do: -1, else: section["credits"]),
          dept_name: section["deptName"],
          display: section["display"],
          grad_basis: section["gradBasis"],
          number: "#{section["number"]}",
          instructors: for instructor <- section["instructors"] do
            %Swampland.Instructors.Instructor{
              name: instructor["name"]
            }
          end,
          meeting_times: for meet_time <- section["meetTimes"] do
            %Swampland.MeetingTimes.MeetingTime{
              beginning: meet_time["meetTimeBegin"],
              end: meet_time["meetTimeEnd"],
              building: meet_time["meetBuilding"],
              day: meet_time["meetDays"] |> Enum.join("|"),
              room: meet_time["meetRoom"],
            }
          end
        }
      end
    }}
  end

  def create_course(course, term) do
    Logger.debug "Creating #{course["code"]}"
    {:ok, course} = get_course(course, term)

    {sections, course} = Map.pop(course, :sections)

    course = Repo.insert!(Map.put(course, :sections, []))

    for section <- sections do
      {instructors, section} = Map.pop(section, :instructors)

      section = Ecto.build_assoc(course, :sections, Map.put(section, :instructors, []))

      section = Repo.insert!(section)

      Ecto.Changeset.change(section)
      |> Ecto.Changeset.put_assoc(:instructors, insert_and_get_all_instructors(instructors))
      |> Repo.update!
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

    names = for instructor <- instructors do
      instructor.name
    end

    maps = for name <- names do
      %{
        name: name,
        inserted_at: {:placeholder, :timestamp},
        updated_at: {:placeholder, :timestamp}
      }
    end

    Repo.insert_all(Instructor, maps, placeholders: placeholders, on_conflict: :nothing)

    Repo.all(from i in Instructor, where: i.name in ^names)
  end
  # Swampland.OneUf.create_course("cop3503", "2188")
  # Swampland.Courses.get_course!(2) |> Swampland.Repo.preload([sections: [:instructors]])
end

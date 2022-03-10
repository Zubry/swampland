defmodule Swampland.OneUf do
  @moduledoc """
  The ONE.UF context
  """
  alias Finch.Response
  alias Swampland.Repo
  alias Ecto.Multi

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       "https://one.uf.edu/" => [size: pool_size()]
     }}
  end

  def pool_size, do: 25

  def get_course(course_code, term) do
    with request <- Finch.build(:get, "https://one.uf.edu/apix/soc/schedule/?category=CWSP&course-code=#{course_code}&term=#{term}"),
         {:ok, %Response{ status: 200, body: body }} <- Finch.request(request, __MODULE__),
         [%{ "TOTALROWS" => 1, "RETRIEVEDROWS" => 1, "COURSES" => courses }] <- Jason.decode!(body),
         course <- hd(courses) do
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
            credits: section["credits"],
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
    else
      err -> {:error, err}
    end
  end

  def create_course(course_code, term) do
    {:ok, course} = get_course(course_code, term)

    {sections, course} = Map.pop(course, :sections)

    course = Repo.insert!(Map.put(course, :sections, []))

    for section <- sections do
      {instructors, section} = Map.pop(section, :instructors)

      section = Ecto.build_assoc(course, :sections, Map.put(section, :instructors, []))

      section = Repo.insert!(section)

      instructors = for instructor <- instructors do
        case Repo.get_by(Swampland.Instructors.Instructor, name: instructor.name) do
          nil ->
            Repo.insert!(instructor)
          instructor ->
            instructor
        end
      end

      Ecto.Changeset.change(section)
      |> Ecto.Changeset.put_assoc(:instructors, instructors)
      |> Repo.update!
    end
  end
  # Swampland.OneUf.create_course("cop3503", "2188")
  # Swampland.Courses.get_course!(1) |> Swampland.Repo.preload([sections: [:instructors, :meeting_times]])
end

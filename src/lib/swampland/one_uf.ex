defmodule Swampland.OneUf do
  @moduledoc """
  The ONE.UF context
  """
  alias Finch.Response

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
      {:ok, %{
        code: course["code"],
        course_id: course["courseId"],
        description: course["description"],
        prerequisites: course["prerequisites"],
        name: course["name"],
        sections: for section <- course["sections"] do
          %{
            acad_career: section["acadCareer"],
            class_number: section["classNumber"],
            credits: section["credits"],
            dept_name: section["deptName"],
            display: section["display"],
            grad_basis: section["gradBasis"],
            number: "#{section["number"]}",
            instructors: for instructor <- section["instructors"] do
              %{
                name: instructor["name"]
              }
            end,
            meeting_times: for meet_time <- section["meetTimes"] do
              %{
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
    with {:ok, course} <- get_course(course_code, term) do
      {:ok, course_repo} = Swampland.Courses.create_course(course)

      for section <- course.sections do
        section_repo = course_repo
          |> Ecto.build_assoc(:sections, section)
          |> Swampland.Repo.insert!

        for instructor <- section.instructors do
          section_repo
            |> Ecto.build_assoc(:instructors, instructor)
            |> Swampland.Repo.insert!
        end

        for meeting_time <- section.meeting_times do
          section_repo
            |> Ecto.build_assoc(:meeting_times, meeting_time)
            |> Swampland.Repo.insert!
        end
      end
      # Swampland.Courses.create_course(course)
    end
  end
  # Swampland.Courses.get_course!(8) |> Swampland.Repo.preload([:sections])
end

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
        name: course["name"]
      }}
    else
      err -> {:error, err}
    end
  end

  def create_course(course_code, term) do
    with {:ok, course} <- get_course(course_code, term) do
      Swampland.Courses.create_course(course)
    end
  end
end

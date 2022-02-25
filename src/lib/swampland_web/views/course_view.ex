defmodule SwamplandWeb.CourseView do
  use SwamplandWeb, :view
  alias SwamplandWeb.CourseView

  def render("index.json", %{courses: courses}) do
    %{data: render_many(courses, CourseView, "course.json")}
  end

  def render("show.json", %{course: course}) do
    %{data: render_one(course, CourseView, "course.json")}
  end

  def render("course.json", %{course: course}) do
    %{id: course.id,
      code: course.code,
      course_id: course.course_id,
      name: course.name,
      description: course.description,
      prerequisites: course.prerequisites}
  end
end

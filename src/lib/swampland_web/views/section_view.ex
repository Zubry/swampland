defmodule SwamplandWeb.SectionView do
  use SwamplandWeb, :view
  alias SwamplandWeb.SectionView

  def render("index.json", %{sections: sections}) do
    %{data: render_many(sections, SectionView, "section.json")}
  end

  def render("show.json", %{section: section}) do
    %{data: render_one(section, SectionView, "section.json")}
  end

  def render("section.json", %{section: section}) do
    %{id: section.id,
      number: section.number,
      class_number: section.class_number,
      grad_basis: section.grad_basis,
      acad_career: section.acad_career,
      display: section.display,
      credits: section.credits,
      dept_name: section.dept_name}
  end
end

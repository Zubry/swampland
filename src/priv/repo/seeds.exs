# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Swampland.Repo.insert!(%Swampland.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Swampland.Repo.insert!(%Swampland.Terms.Term{code: "2228", semester: "Fall", year: "2022"})
Swampland.Repo.insert!(%Swampland.Terms.Term{code: "2225", semester: "Fall", year: "2022"})
Swampland.Repo.insert!(%Swampland.Terms.Term{code: "2221", semester: "Spring", year: "2022"})

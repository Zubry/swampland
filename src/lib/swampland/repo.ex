defmodule Swampland.Repo do
  use Ecto.Repo,
    otp_app: :swampland,
    adapter: Ecto.Adapters.Postgres
end

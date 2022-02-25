# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :swampland,
  ecto_repos: [Swampland.Repo]

# Configures the endpoint
config :swampland, SwamplandWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D85TLlCRtUc0hZSyWVt/VeCXE6usTGmuQfnohI2xim6+T1V+S9rpRfrkqqDadVUE",
  render_errors: [view: SwamplandWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Swampland.PubSub,
  live_view: [signing_salt: "d9cJ1Ph0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

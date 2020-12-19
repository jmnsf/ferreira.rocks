# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ferreira_rocks,
  ecto_repos: [FerreiraRocks.Repo]

# Configures the endpoint
config :ferreira_rocks, FerreiraRocksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Xsze1n2jFzRKk0on6yhw/SiHLJ1nEMlU9x4f7elm5J4Fq2qR4bzCBIs503hSyMCS",
  render_errors: [view: FerreiraRocksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FerreiraRocks.PubSub,
  live_view: [signing_salt: "DcyLu157"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

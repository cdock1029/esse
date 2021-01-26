# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :esse,
  ecto_repos: [Esse.Repo]

# Configures the endpoint
config :esse, EsseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2bpt8ulIMmMnJ6+gCHuMgS+tiFjEJA6JEBu1JuZl83TMbuEochcOyQqD7cZsrOlc",
  render_errors: [view: EsseWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Esse.PubSub,
  live_view: [signing_salt: "U6L2XEbd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

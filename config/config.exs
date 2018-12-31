# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lunchbox_api,
  ecto_repos: [LunchboxApi.Repo]

# Configures the endpoint
config :lunchbox_api, LunchboxApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/iIpL1ZBtSClmO2adO6cpGsYtWjELEjZEXw4I9sTaUfOLZV8CYM1f3QFKF8Sl6wx",
  render_errors: [view: LunchboxApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: LunchboxApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Configure Basic_auth for test
config :lunchbox_api, lunchbox_auth: [
  username: "usernametest",
  password: "passwordtest"
]
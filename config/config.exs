# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :trackhobbs,
  ecto_repos: [Trackhobbs.Repo]

# Configures the endpoint
config :trackhobbs, TrackhobbsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V/w0EO16z9FDDxwk2CjvIbBb90wl8L7SihE7fddldrYrl7p9LOXD/bxb9grhf/G1",
  render_errors: [view: TrackhobbsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Trackhobbs.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

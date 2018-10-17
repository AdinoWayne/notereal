# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :notereal,
  ecto_repos: [Notereal.Repo]

# Configures the endpoint
config :notereal, Notereal.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mfexsseNx9zX8/k6HJ2a+IjoxA9kmYKLwvlV1Zjm0Kg2cax61o2+FQCFiUjEiUbI",
  render_errors: [view: Notereal.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Notereal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# TZdata for DateTime functions
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :secret_santa,
  ecto_repos: [SecretSanta.Repo],
  timezone: System.get_env("TZ")

# Configures the endpoint
config :secret_santa, SecretSantaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EH8AO29qimUAT22bTU2VjPECc1sFtPgcbYe8IkEKi7rVoKMTL+QYTdtVDZ9lunfX",
  render_errors: [view: SecretSantaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SecretSanta.PubSub, adapter: Phoenix.PubSub.PG2]

config :secret_santa, Plug.Session,
  store: :cookie,
  key: "_secret_santa_key",
  signing_salt: "QqCDJAC4",
  max_age: 7200

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :gettext, :default_locale, "et"

config :secret_santa, SecretSanta.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.fastmail.com",
  port: 465,
  hostname: "tarkin.ee",
  # username: {:system, "FASTMAIL_USERNAME"},
  # password: {:system, "FASTMAIL_PASSWORD"}
  username: "marten@tarkin.ee",
  password: "dwtt2ks2ewtbcbud",
  tls: :if_available,
  ssl: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# TZdata for DateTime functions
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :secret_santa,
  ecto_repos: [SecretSanta.Repo],
  timezone: System.get_env("TZ", "Europe/Tallinn")

# Configures the endpoint
config :secret_santa, SecretSantaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EH8AO29qimUAT22bTU2VjPECc1sFtPgcbYe8IkEKi7rVoKMTL+QYTdtVDZ9lunfX",
  render_errors: [view: SecretSantaWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: SecretSanta.PubSub

config :secret_santa, Plug.Session,
  store: :cookie,
  key: "_secret_santa_key",
  signing_salt: "QqCDJAC4",
  max_age: 7200,
  same_site: "Strict"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Oauth2
config :phoenix, :json_library, Jason
config :oauth2, serializers: %{"application/json" => Jason}

config :gettext, :default_locale, "et"

# Configure authentication providers
config :ueberauth, Ueberauth,
  json_library: Jason,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
    facebook: {Ueberauth.Strategy.Facebook, [profile_fields: "name,email,first_name,last_name"]}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "2405378589722224",
  client_secret: "4bfc24b1e76803bba43b1d6e159eee3c"

config :secret_santa, SecretSanta.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.fastmail.com",
  port: 465,
  hostname: "tarkin.ee",
  tls: :if_available,
  ssl: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

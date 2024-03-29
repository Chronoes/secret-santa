import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :secret_santa, SecretSantaWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :secret_santa, SecretSanta.Repo,
  username: "postgres",
  password: "postgres",
  database: "secret_santa_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

defmodule SecretSanta.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      SecretSanta.Repo,
      # Start the endpoint when the application starts
      SecretSantaWeb.Endpoint,
      # Pubsub application
      {Phoenix.PubSub, [name: SecretSanta.PubSub, adapter: Phoenix.PubSub.PG2]}
      # Starts a worker by calling: SecretSanta.Worker.start_link(arg)
      # {SecretSanta.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SecretSanta.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SecretSantaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

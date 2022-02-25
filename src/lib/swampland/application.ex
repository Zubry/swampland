defmodule Swampland.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Swampland.OneUf.child_spec,
      # Start the Ecto repository
      Swampland.Repo,
      # Start the Telemetry supervisor
      SwamplandWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Swampland.PubSub},
      # Start the Endpoint (http/https)
      SwamplandWeb.Endpoint
      # Start a worker by calling: Swampland.Worker.start_link(arg)
      # {Swampland.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Swampland.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SwamplandWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Project.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProjectWeb.Telemetry,
      Project.Repo,
      {DNSCluster, query: Application.get_env(:project, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Project.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Project.Finch},
      # Start a worker by calling: Project.Worker.start_link(arg)
      # {Project.Worker, arg},
      # Start to serve requests, typically the last entry
      ProjectWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Project.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProjectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

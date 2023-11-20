defmodule Impress.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ImpressWeb.Telemetry,
      Impress.Repo,
      {DNSCluster, query: Application.get_env(:impress, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Impress.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Impress.Finch},
      # Start a worker by calling: Impress.Worker.start_link(arg)
      # {Impress.Worker, arg},
      # Start to serve requests, typically the last entry
      ImpressWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Impress.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ImpressWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Trackhobbs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Trackhobbs.Repo,
      # Start the endpoint when the application starts
      TrackhobbsWeb.Endpoint,
      # Starts a worker by calling: Trackhobbs.Worker.start_link(arg)
      # {Trackhobbs.Worker, arg},
#      %{id: Trackhobbs.SlackBot, start: {Trackhobbs.SlackBot, :start_link, ["xoxb-xxxxxxx", name: :testingbot]}}
      {Trackhobbs.SlackBot.Sup, [nil]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: :"Trackhobbs.Supervisor"]
    :observer.start
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TrackhobbsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

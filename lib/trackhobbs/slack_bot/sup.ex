defmodule Trackhobbs.SlackBot.Sup do
  @moduledoc false
  


  use Supervisor

  def start_link(arg) do
    opts = [
      name: :base_bot_supervisor
    ]
    Supervisor.start_link(__MODULE__, arg, opts)
  end

  def init(arg) do
    dynamic_sup_opts = [
      name: :slackbot_supervisor,
      strategy: :one_for_one
    ]
    children = [
      {Trackhobbs.SlackBot.Monitor, []},
      %{id: :slackbot_supervisor, start: {Supervisor, :start_link, [[], dynamic_sup_opts]}}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
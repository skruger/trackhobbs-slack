defmodule Trackhobbs.SlackBot.Monitor do
  @moduledoc false
  require Logger


  use GenServer

  def start_bot(bot_instance) do
    GenServer.cast(:slackbot_monitor, {:start_bot, bot_instance, nil})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [{:name, :slackbot_monitor}])
  end

  def init(_opts) do
    :timer.apply_after(5000, GenServer, :cast, [self(), :start_all_bots])
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end


  def handle_cast({:start_bot, bot_instance, from}, state) do
    childspec = %{id: bot_instance.team_id, start: {Trackhobbs.SlackBot, :start_link, [bot_instance]}}

    case Supervisor.start_child(:slackbot_supervisor, childspec) do
      {:ok, _pid} ->
        Logger.info "Bot started."
        if is_pid(from) do
          GenServer.reply(from, :ok)
        end
      {:error, {:already_started, pid}} ->
        for {team_id, ^pid, _, _} <- Supervisor.which_children(:slackbot_supervisor) do
          Supervisor.terminate_child(:slackbot_supervisor, team_id)
          Supervisor.delete_child(:slackbot_supervisor, team_id)
          Logger.info "Slack bot was already running and is now shut down. Trying to start again..."
          start_bot(bot_instance)
        end
    end
    {:noreply, state}
  end
  def handle_cast(:start_all_bots, state) do
    bot_instances = Trackhobbs.Repo.all Trackhobbs.BotInstance
    Enum.each(bot_instances, fn x -> GenServer.cast(self(), {:start_bot, x, nil}) end)
    {:noreply, state}
  end

  def find_existing_sup_instance(bot_instance) do
    team_id = bot_instance.team_id
    for {team_id, pid, _, _} <- Supervisor.which_children(:slackbot_supervisor) do
      pid
    end
  end
end

defmodule Trackhobbs.SlackBot do
  @moduledoc false

  use Slack
  require Logger

  def start_link(bot_instance) do
    Slack.Bot.start_link(Trackhobbs.SlackBot, %{bot_instance: bot_instance, token: bot_instance.bot_oauth_token}, bot_instance.bot_oauth_token)
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    Logger.info Kernel.inspect(message)
    Logger.info "Team:#{message.team}, Channel:#{message.channel}, User:#{message.user} -> #{message.text}"


    user = Slack.Web.Users.info(message.user, %{token: state.token})
    Logger.info("User info: #{inspect(user)}")

    case Slack.Web.Channels.info(message.channel, %{token: "#{state.token}"}) do
      %{"ok" => true} = info ->
        Logger.info("Channel info: #{inspect(info)}")
        if Regex.run ~r/<@#{state.bot_instance.bot_user_id}>?\s/, message.text do
          send_message("<@#{message.user}> echo: #{message.text}", message.channel, slack)
        end

      _ ->
        send_message("Private echo: #{message.text}", message.channel, slack)
    end
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

end

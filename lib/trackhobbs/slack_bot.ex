defmodule Trackhobbs.SlackBot do
  @moduledoc false

  use Slack

  def start_link(api_token, opts) do
    Slack.Bot.start_link(Trackhobbs.SlackBot, opts, api_token)
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    send_message(message.text, message.channel, slack)
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

end

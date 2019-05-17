defmodule TrackhobbsWeb.OauthController do
  use TrackhobbsWeb, :controller
  require Logger

  def slack(conn, _params) do
    %{"code" => code, "state" => state} = conn.query_params
    slack_id = System.get_env "SLACK_CLIENT_ID"
    slack_secret = System.get_env "SLACK_CLIENT_SECRET"
    slack_access = Slack.Web.Oauth.access(slack_id, slack_secret, code)
#    Logger.info Kernel.inspect(slack_access)
#    request_body = [
#      {"client_id", slack_id},
#      {"client_secret", slack_secret},
#      {"code", code}
#    ]
#    response = HTTPoison.post!("https://slack.com/api/oauth.access", {:form, request_body})
#
#    token_data = Poison.decode! response.body
    Logger.info("Access token: #{inspect(slack_access)}")
    %{"access_token" => access_token, "bot" => bot, "team_id" => team_id} = slack_access
#    instance = nil
    case Trackhobbs.Repo.get_by(Trackhobbs.BotInstance, team_id: team_id) do
      nil ->
        instance = %Trackhobbs.BotInstance{
          team_id: team_id,
          oauth_token: access_token,
          user_id: Map.fetch!(slack_access, "user_id"),
          team_name: Map.fetch!(slack_access, "team_name"),
          bot_user_id: Map.fetch!(bot, "bot_user_id"),
          bot_oauth_token: Map.fetch!(bot, "bot_access_token")
        }
        Trackhobbs.Repo.insert instance
        Trackhobbs.SlackBot.Monitor.start_bot(instance)
        redirect(conn, to: Routes.oauth_path(conn, :slack_done, team_id: instance.team_id))
      instance ->
        updated_properties = %{
          oauth_token: access_token,
          user_id: Map.fetch!(slack_access, "user_id"),
          team_name: Map.fetch!(slack_access, "team_name"),
          bot_user_id: Map.fetch!(bot, "bot_user_id"),
          bot_oauth_token: Map.fetch!(bot, "bot_access_token")
        }
        instance
        |> Trackhobbs.BotInstance.changeset(updated_properties)
        |> Trackhobbs.Repo.update
        Trackhobbs.SlackBot.Monitor.start_bot(instance)
        redirect(conn, to: Routes.oauth_path(conn, :slack_done, team_id: instance.team_id))
    end

#    |> assign(:team_name, Map.fetch!(slack_access, "team_name"))
#    |> render("slack.html")
  end

  def slack_done(conn, _params) do
    %{"team_id" => team_id} = conn.query_params
    bot_instance = Trackhobbs.Repo.get_by!(Trackhobbs.BotInstance, team_id: team_id)
    conn
    |> assign(:bot_instance, bot_instance)
    |> render("slack.html")
  end
end

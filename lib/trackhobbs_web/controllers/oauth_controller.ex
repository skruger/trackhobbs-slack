defmodule TrackhobbsWeb.OauthController do
  use TrackhobbsWeb, :controller

  def slack(conn, _params) do
    %{"code" => code, "state" => state} = conn.query_params
    slack_id = System.get_env "SLACK_CLIENT_ID"
    slack_secret = System.get_env "SLACK_CLIENT_SECRET"
    request_body = [
      {"client_id", slack_id},
      {"client_secret", slack_secret},
      {"code", code}
    ]
    response = HTTPoison.post!("https://slack.com/api/oauth.access", {:form, request_body})

    token_data = Poison.decode! response.body

    %{"access_token" => access_token, "bot" => bot, "team_id" => team_id} = token_data

    case Trackhobbs.Repo.get_by(Trackhobbs.BotInstance, team_id: team_id) do
      nil ->
        instance = %Trackhobbs.BotInstance{
          team_id: team_id,
          oauth_token: access_token,
          bot_oauth_token: Map.fetch!(bot, "bot_access_token")
        }
        Trackhobbs.Repo.insert instance
      instance ->
        updated_properties = %{
          oauth_token: access_token,
          bot_oauth_token: Map.fetch!(bot, "bot_access_token")
        }
        instance
          |> Trackhobbs.BotInstance.changeset(updated_properties)
          |> Trackhobbs.Repo.update
    end
    conn
    |> assign(:team_name, Map.fetch!(token_data, "team_name"))
    |> render("slack.html")
  end
end

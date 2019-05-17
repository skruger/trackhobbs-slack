defmodule TrackhobbsWeb.Router do
  use TrackhobbsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrackhobbsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/oauth/slack", OauthController, :slack
    get "/oauth/slack2", OauthController, :slack_done
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrackhobbsWeb do
  #   pipe_through :api
  # end
end

defmodule TrackhobbsWeb.PageController do
  use TrackhobbsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

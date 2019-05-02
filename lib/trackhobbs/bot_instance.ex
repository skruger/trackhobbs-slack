defmodule Trackhobbs.BotInstance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bot_instances" do
    field :bot_oauth_token, :string
    field :oauth_token, :string
    field :team_id, :string

    timestamps()
  end

  @doc false
  def changeset(bot_instance, attrs) do
    bot_instance
    |> cast(attrs, [:team_id, :oauth_token, :bot_oauth_token])
    |> validate_required([:team_id, :oauth_token, :bot_oauth_token])
  end
end

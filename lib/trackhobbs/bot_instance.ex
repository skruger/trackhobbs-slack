defmodule Trackhobbs.BotInstance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bot_instances" do
    field :bot_oauth_token, :string
    field :bot_user_id, :string
    field :oauth_token, :string
    field :user_id, :string
    field :team_id, :string
    field :team_name, :string

    timestamps()
  end

  @doc false
  def changeset(bot_instance, attrs) do
    bot_instance
    |> cast(attrs, [:team_id, :oauth_token, :bot_oauth_token, :bot_user_id, :user_id, :team_name])
    |> validate_required([:team_id, :oauth_token, :bot_oauth_token, :bot_user_id, :user_id, :team_name])
  end
end

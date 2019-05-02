defmodule Trackhobbs.Repo.Migrations.CreateBotInstances do
  use Ecto.Migration

  def change do
    create table(:bot_instances) do
      add :team_id, :string
      add :oauth_token, :string
      add :bot_oauth_token, :string

      timestamps()
    end

  end
end

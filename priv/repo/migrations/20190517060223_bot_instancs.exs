defmodule Trackhobbs.Repo.Migrations.BotInstancs do
  use Ecto.Migration

  def change do
    alter table(:bot_instances) do
      add :bot_user_id, :string
      add :user_id, :string
      add :team_name, :string
    end

  end
end

defmodule Notereal.Repo.Migrations.Alter do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :user_id, references(:users)
    end
    create table(:posts_tags) do
      add :post_id, references(:posts)
      add :tag_id, references(:tags)
    end
  end
end

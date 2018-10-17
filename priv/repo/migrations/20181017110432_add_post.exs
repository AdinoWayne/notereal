defmodule Notereal.Repo.Migrations.AddPost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :string
      add :vote, :string

      timestamps()
    end
  end
end

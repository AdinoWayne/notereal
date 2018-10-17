defmodule Notereal.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :email, :string
      add :token, :string
      
      timestamps()
    end
  end
end
#mix ecto.gen.migration add_users
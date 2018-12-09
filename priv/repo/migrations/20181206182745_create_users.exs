defmodule SecretSanta.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :password, :string
      add :email, :string
      add :is_admin, :boolean

      timestamps()
    end

    create index(:users, [:name])
    create index(:users, [:password])
  end
end

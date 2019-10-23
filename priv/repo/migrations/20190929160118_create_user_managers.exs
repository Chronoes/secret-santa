defmodule SecretSanta.Repo.Migrations.CreateUserManagers do
  use Ecto.Migration

  def change do
    create table(:user_managers) do
      add :manager_id, references(:users, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
    end

    create unique_index(:user_managers, [:manager_id, :user_id])
    create index(:user_managers, [:user_id, :manager_id])
  end
end

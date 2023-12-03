defmodule SecretSanta.Repo.Migrations.CreateGiftingGroupUsers do
  use Ecto.Migration

  def change do
    create table(:gifting_group_users) do
      add :display_name, :string
      add :is_admin, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :group_id, references(:gifting_groups, on_delete: :nothing)
      add :manager_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:gifting_group_users, [:user_id])
    create index(:gifting_group_users, [:group_id])
  end
end

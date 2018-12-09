defmodule SecretSanta.Repo.Migrations.CreateGiftingPool do
  use Ecto.Migration

  def change do
    create table(:gifting_pool) do
      add :year, :integer
      add :gifter_id, references(:users, on_delete: :nothing)
      add :receiver_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:gifting_pool, [:gifter_id])
    create index(:gifting_pool, [:receiver_id])
    create unique_index(:gifting_pool, [:year, :gifter_id])
    create unique_index(:gifting_pool, [:year, :receiver_id])
  end
end

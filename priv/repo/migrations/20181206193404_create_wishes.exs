defmodule SecretSanta.Repo.Migrations.CreateWishes do
  use Ecto.Migration

  def change do
    create table(:wishes) do
      add :year, :integer
      add :wish, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:wishes, [:user_id])
    create unique_index(:wishes, [:year, :user_id])
  end
end

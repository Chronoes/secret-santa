defmodule SecretSanta.Repo.Migrations.CreateGiftingGroups do
  use Ecto.Migration

  def change do
    create table(:gifting_groups) do
      add :name, :string

      timestamps()
    end
  end
end

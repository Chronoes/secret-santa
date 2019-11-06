defmodule SecretSanta.Repo.Migrations.AddFacebookId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :facebook_id, :string, null: true
    end

    create index(:users, [:facebook_id])
  end
end

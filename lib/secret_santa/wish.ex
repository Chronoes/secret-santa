defmodule SecretSanta.Wish do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wishes" do
    field :wish, :string
    field :year, :integer
    belongs_to(:user, SecretSanta.User)

    timestamps()
  end

  @doc false
  def changeset(wish, attrs) do
    wish
    |> cast(attrs, [:year, :wish])
    |> validate_required([:year, :wish])
  end
end

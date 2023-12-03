defmodule SecretSanta.Gifting.GiftingGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gifting_groups" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(gifting_group, attrs) do
    gifting_group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

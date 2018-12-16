defmodule SecretSanta.GiftingPool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gifting_pool" do
    field :year, :integer
    belongs_to :gifter, SecretSanta.User
    belongs_to :receiver, SecretSanta.User

    timestamps()
  end

  @doc false
  def changeset(gifting_pool, attrs) do
    gifting_pool
    |> cast(attrs, [:year, :gifter_id, :receiver_id])
    |> validate_required([:year])
  end
end

defmodule SecretSanta.Gifting.GiftingPool do
  use Ecto.Schema
  import Ecto.Changeset
  alias SecretSanta.Accounts.User

  schema "gifting_pool" do
    field :year, :integer
    belongs_to :gifter, User
    belongs_to :receiver, User

    timestamps()
  end

  @doc false
  def changeset(gifting_pool, attrs) do
    gifting_pool
    |> cast(attrs, [:year, :gifter_id, :receiver_id])
    |> validate_required([:year])
  end
end

defmodule SecretSanta.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string
    field :plain_password, :string, virtual: true
    field :email, :string
    field :is_admin, :boolean
    has_many(:wishes, SecretSanta.Wish)
    has_many(:gift_targets, SecretSanta.GiftingPool, foreign_key: :gifter_id)
    has_many(:gift_givers, SecretSanta.GiftingPool, foreign_key: :receiver_id)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password, :plain_password, :email, :is_admin])
    |> validate_required([:name, :password, :email, :is_admin])
  end
end

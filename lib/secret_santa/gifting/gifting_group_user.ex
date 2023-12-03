defmodule SecretSanta.Gifting.GiftingGroupUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias SecretSanta.Gifting.GiftingGroup
  alias SecretSanta.Accounts.User

  schema "gifting_group_users" do
    field :display_name, :string
    field :is_admin, :boolean, default: false
    belongs_to :user, User
    belongs_to :group, GiftingGroup
    belongs_to :manager, User

    timestamps()
  end

  @doc false
  def changeset(gifting_group_user, attrs) do
    gifting_group_user
    |> cast(attrs, [:display_name, :is_admin])
    |> validate_required([:display_name, :is_admin])
  end
end

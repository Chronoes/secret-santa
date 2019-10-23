defmodule SecretSanta.Accounts.UserManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias SecretSanta.Accounts.User

  schema "user_managers" do
    belongs_to :manager, User
    belongs_to :user, User
  end

  @doc false
  def changeset(user_manager, attrs) do
    user_manager
    |> cast(attrs, [:manager, :user])
    |> validate_required([:manager, :user])
  end
end

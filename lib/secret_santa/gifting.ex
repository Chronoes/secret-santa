defmodule SecretSanta.Gifting do
  @moduledoc """
  The Gifting context.
  """

  import Ecto.Query, warn: false
  alias SecretSanta.Repo

  alias SecretSanta.Gifting.Wish
  alias SecretSanta.Gifting.GiftingGroup
  alias SecretSanta.Gifting.GiftingGroupUser
  alias SecretSanta.Accounts.User

  @doc """
  Returns the list of wishes.

  ## Examples

      iex> list_wishes()
      [%Wish{}, ...]

  """
  def list_wishes do
    Repo.all(Wish)
  end

  def list_current_wishes(year) do
    Wish
    |> join(:inner, [w], u in assoc(w, :user))
    |> select([w, u], %{w | user: u})
    |> where([w, _u], w.year == ^year)
    |> order_by([_w, u], asc: u.name)
    |> Repo.all()
  end

  @doc """
  Gets a single wish.

  Raises `Ecto.NoResultsError` if the Wish does not exist.

  ## Examples

      iex> get_wish!(123)
      %Wish{}

      iex> get_wish!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wish!(id), do: Repo.get!(Wish, id)

  @spec get_current_wish(User.t(), pos_integer()) :: nil | Wish.t()
  def get_current_wish(user, year) do
    Wish
    |> where(year: ^year, user_id: ^user.id)
    |> Repo.one()
  end

  @doc """
  Creates a wish.

  ## Examples

      iex> create_wish(%{field: value})
      {:ok, %Wish{}}

      iex> create_wish(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wish(attrs \\ %{}) do
    %Wish{}
    |> Wish.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wish.

  ## Examples

      iex> update_wish(wish, %{field: new_value})
      {:ok, %Wish{}}

      iex> update_wish(wish, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wish(%Wish{} = wish, attrs) do
    wish
    |> Wish.changeset(attrs)
    |> Repo.update()
  end

  @spec upsert_wish(Ecto.Changeset.t()) :: any
  def upsert_wish(%Ecto.Changeset{params: params} = wish) do
    wish
    |> Ecto.Changeset.put_assoc(:user, params["user"])
    |> Repo.insert_or_update()
  end

  @doc """
  Deletes a Wish.

  ## Examples

      iex> delete_wish(wish)
      {:ok, %Wish{}}

      iex> delete_wish(wish)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wish(%Wish{} = wish) do
    Repo.delete(wish)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wish changes.

  ## Examples

      iex> change_wish(wish)
      %Ecto.Changeset{source: %Wish{}}

  """
  def change_wish(%Wish{} = wish) do
    Wish.changeset(wish, %{})
  end

  alias SecretSanta.Gifting.GiftingPool

  @doc """
  Returns the list of gifting_pool.

  ## Examples

      iex> list_gifting_pool()
      [%GiftingPool{}, ...]

  """
  def list_gifting_pool do
    Repo.all(GiftingPool)
  end

  @doc """
  Gets a single gifting_pool.

  Raises `Ecto.NoResultsError` if the Gifting pool does not exist.

  ## Examples

      iex> get_gifting_pool!(123)
      %GiftingPool{}

      iex> get_gifting_pool!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gifting_pool!(id), do: Repo.get!(GiftingPool, id)

  @doc """
  Creates a gifting_pool.

  ## Examples

      iex> create_gifting_pool(%{field: value})
      {:ok, %GiftingPool{}}

      iex> create_gifting_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gifting_pool(attrs \\ %{}) do
    %GiftingPool{}
    |> GiftingPool.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gifting_pool.

  ## Examples

      iex> update_gifting_pool(gifting_pool, %{field: new_value})
      {:ok, %GiftingPool{}}

      iex> update_gifting_pool(gifting_pool, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gifting_pool(%GiftingPool{} = gifting_pool, attrs) do
    gifting_pool
    |> GiftingPool.changeset(attrs)
    |> Repo.update()
  end

  def upsert_gifting_pool(%GiftingPool{} = gifting_pool, attrs) do
    gifting_pool
    |> GiftingPool.changeset(
      Map.merge(attrs, %{
        gifter_id: attrs.gifter.id,
        receiver_id: attrs.receiver.id
      })
    )
    |> Repo.insert_or_update!()
  end

  @doc """
  Deletes a GiftingPool.

  ## Examples

      iex> delete_gifting_pool(gifting_pool)
      {:ok, %GiftingPool{}}

      iex> delete_gifting_pool(gifting_pool)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gifting_pool(%GiftingPool{} = gifting_pool) do
    Repo.delete(gifting_pool)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gifting_pool changes.

  ## Examples

      iex> change_gifting_pool(gifting_pool)
      %Ecto.Changeset{source: %GiftingPool{}}

  """
  def change_gifting_pool(%GiftingPool{} = gifting_pool) do
    GiftingPool.changeset(gifting_pool, %{})
  end

  @spec get_gift_receivers(pos_integer(), pos_integer(), [pos_integer()]) :: [User.t()]
  def get_gift_receivers(year, group_id, receiver_ids) do
    GiftingGroupUser
    |> where([u, w], u.group_id == ^group_id and u.user_id in ^receiver_ids)
    |> Repo.all()
    |> Repo.preload(wishes: from(w in Wish, where: w.year == ^year))
  end

  @spec get_current_gifting_pair(pos_integer(), gifter: User.t(), receiver: User.t()) :: GiftingPool.t()
  def get_current_gifting_pair(year, gifter: gifter) do
    GiftingPool
    |> Repo.get_by(year: year, gifter_id: gifter.id)
  end

  def get_current_gifting_pair(year, receiver: receiver) do
    GiftingPool
    |> Repo.get_by(year: year, receiver_id: receiver.id)
  end

  def get_current_gifting_pair(_year, _opts), do: raise("Missing gifter or receiver")

  @spec get_all_gifting_pairs(year :: integer()) :: [GiftingPool.t()]
  def get_all_gifting_pairs(year) do
    GiftingPool
    |> where([gp], gp.year == ^year)
    |> Repo.all()
    |> Repo.preload([:gifter, :receiver])
  end

  @spec create_unique_pairs_of_year(users :: [User.t()], year :: integer()) :: [{User.t(), User.t()}]
  def create_unique_pairs_of_year(users, year), do: create_unique_pairs(users, get_all_gifting_pairs(year - 1))

  @spec create_unique_pairs(users :: [User.t()], prev_pairs :: [GiftingPool.t()]) :: [{User.t(), User.t()}]
  def create_unique_pairs(users, prev_pairs) when length(users) <= 2 or length(prev_pairs) == 0,
    do: SecretSanta.Helpers.pair_up(users)

  def create_unique_pairs(users, prev_pairs) do
    pairs = SecretSanta.Helpers.pair_up(users)

    any_nonuniques? =
      Enum.any?(pairs, fn {gifter, receiver} ->
        Enum.any?(prev_pairs, &(&1.gifter == gifter and &1.receiver == receiver))
      end)

    if any_nonuniques? do
      create_unique_pairs(users, prev_pairs)
    else
      pairs
    end
  end

  @doc """
  Returns the list of gifting_groups.

  ## Examples

      iex> list_gifting_groups()
      [%GiftingGroup{}, ...]

  """
  def list_gifting_groups do
    Repo.all(GiftingGroup)
  end

  @doc """
  Gets a single gifting_group.

  Raises `Ecto.NoResultsError` if the Gifting group does not exist.

  ## Examples

      iex> get_gifting_group!(123)
      %GiftingGroup{}

      iex> get_gifting_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gifting_group!(id), do: Repo.get!(GiftingGroup, id)

  @doc """
  Creates a gifting_group.

  ## Examples

      iex> create_gifting_group(%{field: value})
      {:ok, %GiftingGroup{}}

      iex> create_gifting_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gifting_group(attrs \\ %{}) do
    %GiftingGroup{}
    |> GiftingGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gifting_group.

  ## Examples

      iex> update_gifting_group(gifting_group, %{field: new_value})
      {:ok, %GiftingGroup{}}

      iex> update_gifting_group(gifting_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gifting_group(%GiftingGroup{} = gifting_group, attrs) do
    gifting_group
    |> GiftingGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gifting_group.

  ## Examples

      iex> delete_gifting_group(gifting_group)
      {:ok, %GiftingGroup{}}

      iex> delete_gifting_group(gifting_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gifting_group(%GiftingGroup{} = gifting_group) do
    Repo.delete(gifting_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gifting_group changes.

  ## Examples

      iex> change_gifting_group(gifting_group)
      %Ecto.Changeset{data: %GiftingGroup{}}

  """
  def change_gifting_group(%GiftingGroup{} = gifting_group, attrs \\ %{}) do
    GiftingGroup.changeset(gifting_group, attrs)
  end

  @doc """
  Returns the list of gifting_group_users.

  ## Examples

      iex> list_gifting_group_users()
      [%GiftingGroupUser{}, ...]

  """
  def list_gifting_group_users do
    Repo.all(GiftingGroupUser)
  end

  @doc """
  Gets a single gifting_group_user.

  Raises `Ecto.NoResultsError` if the Gifting group user does not exist.

  ## Examples

      iex> get_gifting_group_user!(123)
      %GiftingGroupUser{}

      iex> get_gifting_group_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gifting_group_user!(id), do: Repo.get!(GiftingGroupUser, id)

  @doc """
  Creates a gifting_group_user.

  ## Examples

      iex> create_gifting_group_user(%{field: value})
      {:ok, %GiftingGroupUser{}}

      iex> create_gifting_group_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gifting_group_user(attrs \\ %{}) do
    %GiftingGroupUser{}
    |> GiftingGroupUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gifting_group_user.

  ## Examples

      iex> update_gifting_group_user(gifting_group_user, %{field: new_value})
      {:ok, %GiftingGroupUser{}}

      iex> update_gifting_group_user(gifting_group_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gifting_group_user(%GiftingGroupUser{} = gifting_group_user, attrs) do
    gifting_group_user
    |> GiftingGroupUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gifting_group_user.

  ## Examples

      iex> delete_gifting_group_user(gifting_group_user)
      {:ok, %GiftingGroupUser{}}

      iex> delete_gifting_group_user(gifting_group_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gifting_group_user(%GiftingGroupUser{} = gifting_group_user) do
    Repo.delete(gifting_group_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gifting_group_user changes.

  ## Examples

      iex> change_gifting_group_user(gifting_group_user)
      %Ecto.Changeset{data: %GiftingGroupUser{}}

  """
  def change_gifting_group_user(%GiftingGroupUser{} = gifting_group_user, attrs \\ %{}) do
    GiftingGroupUser.changeset(gifting_group_user, attrs)
  end
end

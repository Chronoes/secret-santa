defmodule SecretSanta.Gifting do
  @moduledoc """
  The Gifting context.
  """

  import Ecto.Query, warn: false
  alias SecretSanta.Repo

  alias SecretSanta.Gifting.Wish
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
    |> where([w], w.year == ^year)
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
    |> Repo.preload(:user)
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

  def upsert_wish(%Wish{} = wish, attrs) do
    wish
    |> Wish.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, attrs.user)
    |> Repo.insert_or_update!()
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

  @spec get_gift_receivers(pos_integer(), [pos_integer()]) :: [User.t()]
  def get_gift_receivers(year, receiver_ids) do
    User
    |> where([u, w], u.id in ^receiver_ids)
    |> Repo.all()
    |> Repo.preload(wishes: from(w in Wish, where: w.year == ^year))
  end

  @spec get_current_gifting_pair(pos_integer(), User.t()) :: GiftingPool.t()
  def get_current_gifting_pair(year, gifter) do
    GiftingPool
    |> Repo.get_by(year: year, gifter_id: gifter.id)
    |> Repo.preload([:gifter, :receiver])
  end
end

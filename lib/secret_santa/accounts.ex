defmodule SecretSanta.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ueberauth.Auth

  alias SecretSanta.Repo

  alias SecretSanta.Accounts.User
  alias SecretSanta.Accounts.UserManager

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
    |> Repo.preload([:managers])
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_user_password(user) do
    pw = SecretSanta.Helpers.generate_password()

    User.changeset(user, %{
      plain_password: pw,
      password: Bcrypt.hash_pwd_salt(pw)
    })
    |> Repo.update!()
  end

  @spec validate_password(user :: binary(), password :: binary()) :: {:ok, User.t()} | :invalid
  def validate_password("", _password), do: :invalid

  def validate_password(user, password) do
    user = Repo.get_by(User, name: user)

    if !is_nil(user) and Bcrypt.verify_pass(password, user.password) do
      {:ok, user}
    else
      :invalid
    end
  end

  @spec validate_user_from_auth(Ueberauth.Auth.t()) :: :invalid | {:ok, User.t()}
  def validate_user_from_auth(%Auth{provider: :identity, credentials: credentials, extra: extra} = _auth) do
    %Auth.Extra{raw_info: raw} = extra
    %Auth.Credentials{other: %{password: pw}} = credentials

    if Map.has_key?(raw, "username") do
      validate_password(Map.get(raw, "username"), pw)
    else
      :invalid
    end
  end

  def validate_user_from_auth(%Auth{provider: :facebook, uid: uid, info: info} = _auth) do
    user = Repo.get_by(User, facebook_id: uid)

    if is_nil(user) do
      %Auth.Info{first_name: first_name, name: name, email: email} = info
      user = User |> where([u], u.name == ^first_name or u.name == ^name or u.email == ^email) |> Repo.one()

      if is_nil(user) do
        :invalid
      else
        {:ok,
         User.changeset(user, %{facebook_id: uid})
         |> Repo.update!()}
      end
    else
      {:ok, user}
    end
  end

  @spec is_managed_by?(user :: User.t(), manager :: User.t()) :: bool
  def is_managed_by?(user, manager) do
    !is_nil(Repo.get_by(UserManager, user_id: user.id, manager_id: manager.id))
  end
end

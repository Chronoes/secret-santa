defmodule SecretSantaWeb.PageController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Repo
  alias SecretSanta.Accounts
  alias SecretSanta.Gifting

  plug :layout_assigns

  plug :require_auth

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    current_user = get_session(conn, "user")
    current_year = conn.assigns.year

    wishes = Gifting.list_current_wishes(current_year)

    current_user =
      Map.put(
        current_user,
        :current_wish,
        get_user_wish(wishes, current_user.id)
      )
      |> Repo.preload([:managed_users])

    users =
      if current_user.is_admin do
        Accounts.list_users()
        |> Enum.sort(&(&1.name <= &2.name))
      else
        []
      end

    gifting_pool =
      Gifting.get_current_gifting_pair(current_year, gifter: current_user)
      |> Repo.preload([:receiver])

    receiver =
      case gifting_pool && gifting_pool.receiver do
        nil -> nil
        rec -> Map.put(rec, :current_wish, get_user_wish(wishes, rec.id))
      end

    current_user =
      current_user
      |> Map.put(
        :managed_users,
        Enum.map(current_user.managed_users, fn user ->
          Map.put(user, :current_wish, get_user_wish(wishes, user.id))
        end)
      )

    render(conn, "index.html", %{
      user: current_user,
      users: users,
      wishes: wishes,
      receiver: receiver
    })
  end

  defp get_user_wish(wishes, user_id) do
    Enum.find(wishes, fn wish -> wish.user.id == user_id end)
  end

  def require_auth(conn, _opts) do
    if is_nil(get_session(conn, "user")) do
      conn
      |> redirect(to: Routes.auth_path(conn, :login_index))
      |> halt()
    else
      conn
    end
  end
end

defmodule SecretSantaWeb.PageController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Accounts
  alias SecretSanta.Gifting

  plug :layout_assigns

  plug :require_auth

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    current_user = get_session(conn, "user") || %Accounts.User{}
    current_year = conn.assigns.year

    wishes =
      Gifting.list_current_wishes(current_year)
      |> SecretSanta.Repo.preload([:user])

    current_user =
      Map.put(
        current_user,
        :current_wish,
        Enum.find(wishes, fn wish -> wish.user.id == current_user.id end)
      )

    users =
      if current_user.is_admin do
        Accounts.list_users()
      else
        []
      end

    gifting_pool =
      Gifting.get_current_gifting_pair(current_year, current_user)
      |> SecretSanta.Repo.preload([:receiver])

    receiver =
      case gifting_pool && gifting_pool.receiver do
        nil -> nil
        rec -> Map.put(rec, :current_wish, Enum.find(wishes, fn wish -> wish.user.id == rec.id end))
      end

    render(conn, "index.html", %{
      user: current_user,
      users: users,
      wishes: wishes,
      receiver: receiver
    })
  end

  def require_auth(conn, _opts) do
    if is_nil(get_session(conn, "user")) do
      conn
      |> put_status(401)
      |> put_view(SecretSantaWeb.ErrorView)
      |> render(:"401")
      |> halt()
    else
      conn
    end
  end
end

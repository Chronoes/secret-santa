defmodule SecretSantaWeb.PageController do
  use SecretSantaWeb, :controller
  import Ecto.Query

  plug :layout_assigns

  plug :require_auth

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    current_user = get_session(conn, "user") || %SecretSanta.User{}
    current_year = conn.assigns.year

    wishes =
      SecretSanta.Wish
      |> where(year: ^current_year)
      |> SecretSanta.Repo.all()
      |> SecretSanta.Repo.preload([:user])

    current_user = %{
      current_user
      | wishes: Enum.find(wishes, fn w -> w.user.id == current_user.id end) |> List.wrap()
    }

    users =
      if current_user.is_admin do
        SecretSanta.User |> SecretSanta.Repo.all()
      else
        []
      end

    gifting_pool =
      SecretSanta.GiftingPool
      |> where(year: ^current_year, gifter_id: ^current_user.id)
      |> SecretSanta.Repo.one()
      |> SecretSanta.Repo.preload([:receiver])

    render(conn, "index.html", %{
      user: current_user,
      users: users,
      wishes: wishes,
      receiver: (gifting_pool && gifting_pool.receiver) || nil
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

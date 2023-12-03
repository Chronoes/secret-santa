defmodule SecretSantaWeb.AuthController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Accounts

  plug Ueberauth
  plug :layout_assigns

  @spec login_index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login_index(conn, params) do
    render(conn, "login.html", %{
      auth_changeset: %{
        "username" => params["username"] || "",
        "password" => params["password"] || ""
      }
    })
  end

  @spec request(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def request(conn, %{"provider" => "identity"} = _params) do
    redirect(conn, to: ~p"/auth")
  end

  @spec callback(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, params) do
    case Accounts.validate_user_from_auth(auth) do
      {:ok, user} ->
        conn |> put_session("user", user) |> redirect(to: "/")

      :invalid ->
        conn
        |> put_flash(:error, dgettext("errors", "invalidLogin"))
        |> login_index(params)
    end
  end
end

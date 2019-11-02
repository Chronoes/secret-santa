defmodule SecretSantaWeb.AuthController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Accounts
  alias Ueberauth.Auth

  plug Ueberauth
  plug :layout_assigns

  @spec login_index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login_index(conn, _params) do
    render(conn, "login.html", %{
      identity_callback_url: Routes.auth_path(conn, :callback, "identity"),
      facebook_request_url: Routes.auth_path(conn, :request, "facebook")
    })
  end

  @spec request(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def request(conn, %{"provider" => "identity"} = _params) do
    redirect(conn, to: Routes.auth_path(conn, :login_index))
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

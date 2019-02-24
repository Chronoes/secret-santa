defmodule SecretSantaWeb.AuthController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Accounts

  plug :layout_assigns

  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login(conn, params) do
    render(conn, "login.html", %{user_id: params["id"]})
  end

  @spec auth(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def auth(conn, %{"password" => password} = params) do
    case Accounts.authenticate_user(params["id"], password) do
      nil ->
        conn
        |> put_flash(:error, dgettext("errors", "invalidLogin"))
        |> login(params)

      user ->
        conn |> put_session("user", user) |> redirect(to: "/")
    end
  end
end

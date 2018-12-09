defmodule SecretSantaWeb.AuthController do
  use SecretSantaWeb, :controller

  plug :layout_assigns

  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login(conn, params) do
    render(conn, "login.html", %{user_id: params["id"]})
  end

  @spec auth(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def auth(conn, %{"password" => password} = params) do
    case get_user(params["id"], password) do
      nil ->
        conn
        |> put_flash(:error, dgettext("errors", "invalidLogin"))
        |> login(params)

      user ->
        conn |> put_session("user", user) |> redirect(to: "/")
    end
  end

  defp get_user("", _password), do: nil

  defp get_user(user_id, password) do
    user = SecretSanta.Repo.get!(SecretSanta.User, user_id)

    if !is_nil(user) and Bcrypt.verify_pass(password, user.password) do
      user
    else
      nil
    end
  end
end

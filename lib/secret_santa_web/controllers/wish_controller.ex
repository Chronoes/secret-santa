defmodule SecretSantaWeb.WishController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Accounts
  alias SecretSanta.Gifting

  plug :layout_assigns

  def change_wish(conn, %{"wish" => wish_text} = _params) do
    current_user = get_session(conn, "user")
    current_year = conn.assigns.year

    wish =
      (Gifting.get_current_wish(current_user, current_year) |> SecretSanta.Repo.preload([:user]) || %Gifting.Wish{})
      |> Gifting.upsert_wish(%{year: current_year, wish: wish_text, user: current_user})

    case wish do
      {:ok, _cs} ->
        conn |> redirect(to: Routes.page_path(conn, :index))

      {:error, cs} ->
        conn
        |> put_flash(:error, Enum.map(cs.errors, &error_string/1) |> Enum.join("\n"))
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp error_string({name, {reason, opts}}) do
    case name do
      :wish ->
        "#{gettext("wish")} #{Gettext.dgettext(SecretSantaWeb.Gettext, "errors", reason, opts)}"
    end
  end

  def create_pool(conn, %{"receivers" => receivers} = _params) do
    current_year = conn.assigns.year

    users =
      Gifting.get_gift_receivers(current_year, receivers)
      |> Enum.map(&Accounts.change_user_password/1)

    SecretSanta.Helpers.pair_up(users)
    |> Enum.each(fn {gifter, receiver} ->
      (Gifting.get_current_gifting_pair(current_year, gifter)
       |> SecretSanta.Repo.preload([:gifter, :receiver]) || %Gifting.GiftingPool{})
      |> Gifting.upsert_gifting_pool(%{
        year: current_year,
        gifter: gifter,
        receiver: receiver
      })

      SecretSantaWeb.Emails.gifter_email(gifter.email, %{
        year: current_year,
        gifter: gifter,
        receiver: receiver,
        login_url: Routes.auth_url(conn, :login, gifter.id)
      })
      |> SecretSanta.Mailer.deliver_now()
    end)

    conn |> redirect(to: "/")
  end
end
defmodule SecretSantaWeb.WishController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Accounts
  alias SecretSanta.Gifting
  alias SecretSanta.Gifting.GiftingPool

  plug :layout_assigns

  def change_wish(conn, %{"wish" => wish_text} = params) do
    current_user = get_session(conn, "user")
    current_year = conn.assigns.year

    changeset =
      (Gifting.get_current_wish(current_user, current_year) |> SecretSanta.Repo.preload([:user]) || %Gifting.Wish{})
      |> Gifting.Wish.changeset(%{
        year: current_year,
        wish: wish_text,
        user: current_user
      })

    case Gifting.upsert_wish(changeset) do
      {:ok, wish} ->
        case Gifting.get_current_gifting_pair(wish.year, receiver: wish.user)
             |> SecretSanta.Repo.preload([:gifter]) do
          nil ->
            nil

          pair ->
            # Send mail if wish has changed
            unless is_nil(Ecto.Changeset.get_change(changeset, :wish)) do
              SecretSantaWeb.Emails.wish_changed_email(pair.gifter.email, %{
                year: wish.year,
                gifter: pair.gifter,
                receiver: wish.user,
                wish: wish.wish
              })
              |> SecretSanta.Mailer.deliver_later()
            end
        end

        process_other_wishes(params, current_user, current_year)

        conn |> redirect(to: Routes.page_path(conn, :index))

      {:error, cs} ->
        conn
        |> put_flash(:error, Enum.map(cs.errors, &error_string/1) |> Enum.join("\n"))
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp process_other_wishes(%{"wishes" => wishes} = _params, current_user, current_year) do
    wishes
    |> Enum.map(fn {user_id, wish} -> {Accounts.get_user!(user_id), wish} end)
    |> Enum.filter(fn {user, wish} -> wish != "" && Accounts.is_managed_by?(user, current_user) end)
    |> Enum.map(fn {user, wish} ->
      (Gifting.get_current_wish(user, current_year) |> SecretSanta.Repo.preload([:user]) || %Gifting.Wish{})
      |> Gifting.Wish.changeset(%{
        year: current_year,
        wish: wish,
        user: user
      })
      |> Gifting.upsert_wish()
    end)
  end

  defp process_other_wishes(_params, _user, _year), do: nil

  defp error_string({name, {reason, opts}}) do
    case name do
      :wish ->
        "#{gettext("wish")} #{Gettext.dgettext(SecretSantaWeb.Gettext, "errors", reason, opts)}"
    end
  end

  def create_pool(conn, %{"receivers" => receivers} = _params) do
    current_year = conn.assigns.year

    Gifting.get_gift_receivers(current_year, 1, receivers)
    |> Gifting.create_unique_pairs_of_year(current_year)
    |> Enum.each(fn {gifter, receiver} ->
      (Gifting.get_current_gifting_pair(current_year, gifter: gifter)
       |> SecretSanta.Repo.preload([:gifter, :receiver]) || %Gifting.GiftingPool{})
      |> Gifting.upsert_gifting_pool(%{
        year: current_year,
        gifter: gifter,
        receiver: receiver
      })
    end)

    conn |> redirect(to: "/")
  end

  def send_emails(conn, _params) do
    current_year = conn.assigns.year

    pairs = Gifting.get_all_gifting_pairs(current_year)

    pairs
    |> Enum.map(fn pair ->
      gifter = Accounts.change_user_password(pair.gifter)
      %GiftingPool{pair | gifter: gifter}
    end)
    |> Enum.each(fn %GiftingPool{gifter: gifter, receiver: receiver} ->
      SecretSantaWeb.Emails.gifter_email(gifter.email, %{
        year: current_year,
        gifter: gifter,
        receiver: receiver,
        login_url: Routes.auth_url(conn, :login_index, username: gifter.name)
      })
      |> SecretSanta.Mailer.deliver_now()
    end)

    conn |> redirect(to: "/")
  end
end

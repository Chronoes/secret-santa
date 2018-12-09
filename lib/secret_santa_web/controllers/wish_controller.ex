defmodule SecretSantaWeb.WishController do
  use SecretSantaWeb, :controller
  alias SecretSanta.Repo
  import Ecto.Query

  plug :layout_assigns

  def change_wish(conn, %{"wish" => wish_text} = _params) do
    current_user = get_session(conn, "user")
    current_year = conn.assigns.year

    wish =
      (SecretSanta.Wish
       |> where(year: ^current_year, user_id: ^current_user.id)
       |> Repo.one()
       |> Repo.preload(:user) || %SecretSanta.Wish{})
      |> SecretSanta.Wish.changeset(%{year: current_year, wish: wish_text})
      |> Ecto.Changeset.put_assoc(:user, current_user)
      |> Repo.insert_or_update!()

    conn |> redirect(to: "/")
  end

  def create_pool(conn, %{"receivers" => receivers} = _params) do
    current_year = conn.assigns.year

    users =
      SecretSanta.User
      |> where([u, w], u.id in ^receivers)
      |> Repo.all()
      |> Repo.preload(wishes: from(w in SecretSanta.Wish, where: w.year == ^current_year))
      |> Enum.map(fn user ->
        pw = SecretSanta.Helpers.generate_password()

        SecretSanta.User.changeset(user, %{
          plain_password: pw,
          password: Bcrypt.hash_pwd_salt(pw)
        })
        |> Repo.update!()
      end)

    SecretSanta.Helpers.pair_up(users)
    |> Enum.each(fn {gifter, receiver} ->
      (SecretSanta.GiftingPool
       |> Repo.get_by(year: current_year, gifter_id: gifter.id)
       |> Repo.preload([:gifter, :receiver]) || %SecretSanta.GiftingPool{})
      |> SecretSanta.GiftingPool.changeset(%{
        year: current_year
      })
      |> Ecto.Changeset.put_assoc(:gifter, gifter)
      |> Ecto.Changeset.put_assoc(:receiver, receiver)
      |> Repo.insert_or_update!()

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

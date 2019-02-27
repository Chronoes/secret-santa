defmodule SecretSantaWeb.Emails do
  use Bamboo.Phoenix, view: SecretSantaWeb.EmailView
  import Bamboo.Email
  import SecretSantaWeb.Gettext

  def gifter_email(receiver, assigns) do
    new_santa_email()
    |> to(receiver)
    |> subject(dgettext("email", "secretSanta", year: assigns.year))
    |> render("gifter_email.text", assigns)
  end

  def wish_changed_email(receiver, assigns) do
    new_santa_email()
    |> to(receiver)
    |> subject(dgettext("email", "secretSanta.wishChanged", year: assigns.year))
    |> render(:wish_changed_email, assigns)
  end

  defp new_santa_email() do
    new_email()
    |> from("joulud@tarkin.ee")
    |> put_text_layout({SecretSantaWeb.LayoutView, "email.text"})
    |> put_html_layout({SecretSantaWeb.LayoutView, "email.html"})
  end
end

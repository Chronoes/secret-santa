defmodule SecretSantaWeb.Emails do
  use Bamboo.Phoenix, view: SecretSantaWeb.EmailView
  import Bamboo.Email
  import SecretSantaWeb.Gettext

  def gifter_email(receiver, assigns) do
    new_email()
    |> from("joulud@tarkin.ee")
    |> to(receiver)
    |> subject(dgettext("email", "secretSanta", year: assigns.year))
    |> put_text_layout({SecretSantaWeb.LayoutView, "email.text"})
    |> render("gifter_email.text", assigns)
  end
end

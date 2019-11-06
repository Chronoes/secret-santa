defmodule SecretSantaWeb.PrivacyController do
  use SecretSantaWeb, :controller

  @spec privacy(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end
end

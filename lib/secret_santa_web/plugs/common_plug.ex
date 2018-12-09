defmodule SecretSantaWeb.CommonPlug do
  import Plug.Conn

  def layout_assigns(conn, _opts) do
    conn
    |> assign(:year, DateTime.utc_now().year)
  end
end

defmodule SecretSantaWeb.PageView do
  use SecretSantaWeb, :view

  def convert_to_hyperlinks(text) do
    regex = ~r/(?:https?|ftp):\/\/[^\s\/$.?#].[^\s]*/i

    String.split(text, regex, trim: true, include_captures: true)
    |> Enum.map(&wrap_links(regex, &1))
  end

  defp wrap_links(link_regex, part) do
    if String.match?(part, link_regex) do
      String.replace(part, ~r/^[!"#$%&'()*+,-.\/@\:;<=>\[\]^_`{|}~]+/, "")
      |> String.replace(~r/[!"#$%&'()*+,-.\/@:;<=>\[\]^_`{|}~]+$/, "")
      |> link_element()
    else
      part
    end
  end

  defp link_element(url) do
    link(url, to: url, target: "_blank", rel: "noreferrer noopener")
  end
end

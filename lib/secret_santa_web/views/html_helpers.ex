defmodule SecretSantaWeb.HTMLHelpers do
  use Phoenix.HTML

  @spec convert_to_hyperlinks(binary(), keyword()) :: [binary() | Phoenix.HTML.safe()]
  def convert_to_hyperlinks(text, opts \\ []) do
    regex = ~r/(?:https?|ftp):\/\/[^\s\/$.?#].[^\s]*/i

    String.split(text, regex, trim: true, include_captures: true)
    |> Enum.map(&wrap_links(regex, &1, opts))
  end

  defp wrap_links(link_regex, part, opts) do
    if String.match?(part, link_regex) do
      String.replace(part, ~r/^[!"#$%&'()*+,-.\/@\:;<=>\[\]^_`{|}~]+/, "")
      |> String.replace(~r/[!"#$%&'()*+,-.\/@:;<=>\[\]^_`{|}~]+$/, "")
      |> link_element(opts)
    else
      part
    end
  end

  defp link_element(url, opts) do
    link(url, Keyword.merge(opts, to: url, target: "_blank", rel: "noreferrer noopener"))
  end

  @spec unsafe_to_safe(list :: [Phoenix.HTML.unsafe() | Phoenix.HTML.safe()], opts :: keyword()) :: [
          Phoenix.HTML.safe()
        ]
  def unsafe_to_safe(list, opts \\ [])
  def unsafe_to_safe([], _opts), do: []
  def unsafe_to_safe([{:safe, a} | rest], opts), do: [{:safe, a} | unsafe_to_safe(rest, opts)]
  def unsafe_to_safe([unsafe | rest], opts), do: [text_to_html(unsafe, opts) | unsafe_to_safe(rest, opts)]
end

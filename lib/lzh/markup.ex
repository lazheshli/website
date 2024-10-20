defmodule Lzh.Markup do
  alias Phoenix.HTML

  @doc """
  Convert the basic markdown used in some text fields into HTML.

      iex> to_html("*hi!*")
      "<p><em>hi!</em></p>"

  """
  def to_html(text) do
    text
    |> HTML.html_escape()
    |> HTML.safe_to_string()
    |> String.trim()
    |> String.split("\n", trim: false)
    |> Enum.intersperse("<br>")
    |> Enum.join()
    |> handle_inline_links()
    |> handle_strong_emphasis()
    |> handle_emphasis()
  end

  # Handle markdown inline links (as opposed to reference links), e.g. [an
  # example](http://example.com/).
  #
  # Unlike markdown's inline links, these support neither relative URLs nor
  # setting the title attribute.
  #
  # Produced <a> tags should feature rel=noopener (as suggested for Matrix chat
  # messages [1]) — which is implied by target=_blank [2].
  #
  # [1]: https://spec.matrix.org/v1.3/client-server-api/#mroommessage-msgtypes
  # [2]: https://developer.mozilla.org/en-US/docs/Web/HTML/Link_types/noopener
  defp handle_inline_links(text) do
    Regex.replace(
      ~r/\[(.+)\]\(([A-Za-z0-9+.-]+:\/\/[\p{L}0-9.:\/_?&=+#-]+)\)/u,
      text,
      fn match, link_text, link_url ->
        if valid_url?(link_url) do
          "<a href=\"#{link_url}\" target=\"_blank\" class=\"underline\">#{link_text}</a>"
        else
          match
        end
      end
    )
  end

  # Handle markdown emphasis.
  defp handle_emphasis(text) do
    Regex.replace(~r/(?<!\\)(\*|_)(?![\s\*_])(.+?)(?<![\s\*_])\1/, text, "<em>\\2</em>")
  end

  # Handle markdown strong emphasis.
  defp handle_strong_emphasis(text) do
    Regex.replace(~r/(?<!\\)(\*\*|__)(?!\s)(.+?)(?<!\s)\1(?![\*_])/, text, "<strong>\\2</strong>")
  end

  defp valid_url?(string) do
    uri = URI.parse(string)
    uri.scheme != nil and uri.host != nil
  end
end

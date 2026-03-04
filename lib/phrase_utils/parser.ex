defmodule PhraseUtils.Parser do
  @moduledoc false

  @spec parse(String.t()) :: [String.t()]
  def parse(input) when is_binary(input) do
    scan(input, :default, [], [])
  end

  # Default state — skip whitespace, start quoted or word tokens
  defp scan(<<c, rest::binary>>, :default, _acc, tokens) when c in [?\s, ?\t, ?\n, ?\r] do
    scan(rest, :default, [], tokens)
  end

  defp scan(<<?", rest::binary>>, :default, _acc, tokens) do
    scan(rest, :quoted, [], tokens)
  end

  defp scan(<<c, rest::binary>>, :default, _acc, tokens) do
    scan(rest, :word, [c], tokens)
  end

  # Word state — whitespace emits, quote transitions to quoted (carrying prefix)
  defp scan(<<c, rest::binary>>, :word, acc, tokens) when c in [?\s, ?\t, ?\n, ?\r] do
    scan(rest, :default, [], [emit(acc) | tokens])
  end

  defp scan(<<?", rest::binary>>, :word, acc, tokens) do
    scan(rest, :quoted, acc, tokens)
  end

  defp scan(<<c, rest::binary>>, :word, acc, tokens) do
    scan(rest, :word, [c | acc], tokens)
  end

  # Quoted state — escape sequences, closing quote, accumulate
  defp scan(<<?\\, ?", rest::binary>>, :quoted, acc, tokens) do
    scan(rest, :quoted, [?" | acc], tokens)
  end

  defp scan(<<?\\, ?\\, rest::binary>>, :quoted, acc, tokens) do
    scan(rest, :quoted, [?\\ | acc], tokens)
  end

  defp scan(<<?", rest::binary>>, :quoted, acc, tokens) do
    scan(rest, :default, [], [emit(acc) | tokens])
  end

  defp scan(<<c, rest::binary>>, :quoted, acc, tokens) do
    scan(rest, :quoted, [c | acc], tokens)
  end

  # End of input
  defp scan(<<>>, :default, _acc, tokens) do
    Enum.reverse(tokens)
  end

  defp scan(<<>>, _state, acc, tokens) do
    Enum.reverse([emit(acc) | tokens])
  end

  defp emit(acc) do
    acc |> Enum.reverse() |> IO.iodata_to_binary()
  end
end

defmodule PhraseUtils do
  @moduledoc """
  A phrase-aware string splitter for query parsing.

  Splits strings on whitespace while respecting double-quoted phrases and prefix
  operators. Useful as a building block for search query parsers.
  """

  @doc """
  Splits a string into tokens, preserving quoted phrases.

  Words are separated by whitespace. Double-quoted substrings are kept as single
  tokens. A prefix immediately before a quote (e.g. `-"spam"`) is merged into
  the resulting token.

  ## Examples

      iex> PhraseUtils.split("hello world")
      ["hello", "world"]

      iex> PhraseUtils.split(~s[hello "big world"])
      ["hello", "big world"]

      iex> PhraseUtils.split(~s[-"spam" +"eggs"])
      ["-spam", "+eggs"]

      iex> PhraseUtils.split("")
      []

  """
  @spec split(String.t()) :: [String.t()]
  def split(input) when is_binary(input) do
    PhraseUtils.Parser.parse(input)
  end
end

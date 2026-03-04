# PhraseUtils

[![CI](https://github.com/mylanconnolly/phrase_utils/actions/workflows/ci.yml/badge.svg)](https://github.com/mylanconnolly/phrase_utils/actions/workflows/ci.yml)

A phrase-aware string splitter for query parsing in Elixir.

Splits strings on whitespace while respecting double-quoted phrases and prefix
operators. Useful as a building block for search query parsers.

## Usage

```elixir
PhraseUtils.split("hello world")
#=> ["hello", "world"]

PhraseUtils.split(~s[hello "big world"])
#=> ["hello", "big world"]

PhraseUtils.split(~s[-"spam" +"eggs"])
#=> ["-spam", "+eggs"]
```

## Installation

Add `phrase_utils` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phrase_utils, "~> 0.1.0"}
  ]
end
```

## License

MIT — see [LICENSE](LICENSE).

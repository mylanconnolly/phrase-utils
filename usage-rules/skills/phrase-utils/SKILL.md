---
name: phrase-utils
description: "Use this skill when splitting user input or search queries into tokens that respect double-quoted phrases."
---

# PhraseUtils

Phrase-aware string splitter for query parsing. One public function: `PhraseUtils.split/1`.

## API

```elixir
PhraseUtils.split("hello world")           #=> ["hello", "world"]
PhraseUtils.split(~s[hello "big world"])    #=> ["hello", "big world"]
PhraseUtils.split(~s[-"spam" +"eggs"])      #=> ["-spam", "+eggs"]
PhraseUtils.split("")                       #=> []
```

**Input:** `String.t()` — **Output:** `[String.t()]`

## Behavior

- Splits on whitespace (space, tab, `\n`, `\r`)
- Double-quoted substrings become single tokens
- Prefix characters before a quote merge into the token: `-"spam"` → `"-spam"`
- `\"` inside quotes → literal `"`, `\\` → literal `\`
- Unclosed quotes emit the partial phrase as-is (best-effort, no errors)
- Empty quotes (`""`) produce an empty string token `""`
- Single quotes are ordinary characters, not delimiters
- All Unicode works correctly — only ASCII whitespace and `"` are special

## When to use

- First step when parsing user search queries
- Any time you need whitespace splitting that preserves quoted phrases

## When not to use

- Do not use `String.split/2` for phrase-aware splitting — it cannot handle quoted phrases
- Do not pass non-binary input

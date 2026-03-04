defmodule PhraseUtilsTest do
  use ExUnit.Case, async: true
  doctest PhraseUtils

  describe "split/1 — core" do
    test "space-separated words" do
      assert PhraseUtils.split("hello world") == ["hello", "world"]
    end

    test "quoted phrase" do
      assert PhraseUtils.split(~s[hello "big world"]) == ["hello", "big world"]
    end

    test "prefixed quoted phrase" do
      assert PhraseUtils.split(~s[-"spam" +"eggs"]) == ["-spam", "+eggs"]
    end

    test "single word" do
      assert PhraseUtils.split("hello") == ["hello"]
    end
  end

  describe "split/1 — whitespace handling" do
    test "empty string" do
      assert PhraseUtils.split("") == []
    end

    test "whitespace only" do
      assert PhraseUtils.split("   ") == []
    end

    test "leading and trailing whitespace" do
      assert PhraseUtils.split("  hello world  ") == ["hello", "world"]
    end

    test "multiple spaces between words" do
      assert PhraseUtils.split("hello    world") == ["hello", "world"]
    end

    test "tabs as delimiters" do
      assert PhraseUtils.split("hello\tworld") == ["hello", "world"]
    end

    test "newlines as delimiters" do
      assert PhraseUtils.split("hello\nworld") == ["hello", "world"]
    end

    test "carriage return + newline" do
      assert PhraseUtils.split("hello\r\nworld") == ["hello", "world"]
    end

    test "mixed whitespace" do
      assert PhraseUtils.split(" \t hello \n world \r\n ") == ["hello", "world"]
    end
  end

  describe "split/1 — quoted phrases" do
    test "quote at beginning" do
      assert PhraseUtils.split(~s["hello world" foo]) == ["hello world", "foo"]
    end

    test "quote at end" do
      assert PhraseUtils.split(~s[foo "hello world"]) == ["foo", "hello world"]
    end

    test "only a quoted phrase" do
      assert PhraseUtils.split(~s["hello world"]) == ["hello world"]
    end

    test "multiple quoted phrases" do
      assert PhraseUtils.split(~s["hello world" "foo bar"]) == ["hello world", "foo bar"]
    end

    test "empty quotes" do
      assert PhraseUtils.split(~s[hello ""]) == ["hello", ""]
    end

    test "unclosed quote" do
      assert PhraseUtils.split(~s[hello "big world]) == ["hello", "big world"]
    end

    test "no space after closing quote" do
      assert PhraseUtils.split(~s["hello"world]) == ["hello", "world"]
    end
  end

  describe "split/1 — prefixes" do
    test "minus prefix" do
      assert PhraseUtils.split(~s[-"spam"]) == ["-spam"]
    end

    test "plus prefix" do
      assert PhraseUtils.split(~s[+"eggs"]) == ["+eggs"]
    end

    test "tilde prefix" do
      assert PhraseUtils.split(~s[~"fuzzy"]) == ["~fuzzy"]
    end

    test "multi-character prefix" do
      assert PhraseUtils.split(~s[--"flag"]) == ["--flag"]
    end
  end

  describe "split/1 — escape sequences inside quotes" do
    test "escaped double quote" do
      assert PhraseUtils.split(~s["say \\"hello\\""]) == [~s[say "hello"]]
    end

    test "escaped backslash" do
      assert PhraseUtils.split(~s["path\\\\dir"]) == [~s[path\\dir]]
    end

    test "backslash before non-special character is literal" do
      assert PhraseUtils.split(~s["hello\\nworld"]) == [~s[hello\\nworld]]
    end
  end

  describe "split/1 — single quotes" do
    test "single quotes are literal characters" do
      assert PhraseUtils.split("it's a test") == ["it's", "a", "test"]
    end
  end

  describe "split/1 — unicode" do
    test "unicode words" do
      assert PhraseUtils.split("café résumé") == ["café", "résumé"]
    end

    test "unicode inside quotes" do
      assert PhraseUtils.split(~s["日本語" hello]) == ["日本語", "hello"]
    end

    test "emoji" do
      assert PhraseUtils.split("hello 🌍") == ["hello", "🌍"]
    end
  end
end

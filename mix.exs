defmodule PhraseUtils.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/mylanconnolly/phrase_utils"

  def project do
    [
      app: :phrase_utils,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "PhraseUtils",
      description: "A phrase-aware string splitter for query parsing.",
      source_url: @source_url,
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.35", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib mix.exs README.md LICENSE usage-rules)
    ]
  end

  defp docs do
    [
      main: "PhraseUtils",
      source_ref: "v#{@version}"
    ]
  end
end

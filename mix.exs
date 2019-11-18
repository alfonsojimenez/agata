defmodule Agata.Mixfile do
  use Mix.Project

  def project do
    [
      app: :agata,
      version: "1.0.0",
      elixir: "~> 1.7",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex],
      mod: {Agata, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.7"},
      {:eiconv, "~> 1.0"},
      {:expug, "~> 0.9"},
      {:mailman, "~> 0.4"},
      {:plug_cowboy, "~> 2.1"},
      {:plug, "~> 1.7"},
      {:poison, "~> 4.0"}
    ]
  end
end

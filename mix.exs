defmodule Agata.Mixfile do
  use Mix.Project

  def project do
    [
      app: :agata,
      version: "0.1.0",
      elixir: "~> 1.4",
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
      {:cowboy, "~> 1.1"},
      {:eiconv, github: "zotonic/eiconv"},
      {:expug, "~> 0.9"},
      {:mailman, "~> 0.3.0"},
      {:plug, "~> 1.4"},
      {:poison, "~> 3.1"}
    ]
  end
end

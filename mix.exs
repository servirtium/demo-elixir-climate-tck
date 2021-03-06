defmodule ServirtiumDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :servirtium_demo,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:sweet_xml, "~> 0.6"},
      {:servirtium_elixir, path: "../servirtium_elixir"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end

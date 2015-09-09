defmodule Passport.Mixfile do
  use Mix.Project

  def project do
    [app: :passport,
     description: "Provides authentication for phoenix applications",
     version: "0.0.3",
     elixir: "~> 1.0",
     package: package,
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp package do
    [contributors: ["Shankar Dhanasekaran - (shankardevy)"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/opendrops/passport"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
     [{:phoenix, "~> 1.0.2"},
     {:phoenix_ecto, "~> 1.2.0"},
     {:comeonin, "~> 1.1"},
     {:excoveralls, "~> 0.3.10", only: [:dev, :test]},
     {:mock, ">= 0.0.0", only: [:dev, :test]}]
  end
end

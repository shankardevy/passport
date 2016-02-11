defmodule Passport.Mixfile do
  use Mix.Project

  def project do
    [app: :passport,
     description: "Provides authentication for phoenix applications",
     version: "0.0.4",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger, :comeonin]]
  end

  defp package do
    [maintainers: ["Shankar Dhanasekaran - (shankardevy)"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/opendrops/passport"}]
  end

  defp deps do
    [
      {:phoenix, "~> 1.1.2"},
      {:comeonin, "~> 2.0"}]
  end

end

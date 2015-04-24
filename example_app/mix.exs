defmodule ExampleApp.Mixfile do
  use Mix.Project

  def project do
    [app: :example_app,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ExampleApp, []},
     applications: [:phoenix, :cowboy, :logger]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, github: "phoenixframework/phoenix", override: true},
     {:phoenix_ecto, "~> 0.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_live_reload, "~> 0.2"},
     {:cowboy, "~> 1.0"}]
  end
end

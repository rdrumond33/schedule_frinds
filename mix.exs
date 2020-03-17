defmodule ScheduleFrinds.MixProject do
  use Mix.Project

  def project do
    [
      app: :schedule_frinds,
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
      {:nimble_csv, "~>0.7.0"},
      {:faker, "~> 0.13.0"},
      {:scribe, "~> 0.10.0"}
    ]
  end
end

defmodule ElixirGenTcp.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_gen_tcp,
      version: "0.1.4",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      # Now, when we run iex -S mix, we will run the Application
      mod: {GenTcp.Application, [:type, :args]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

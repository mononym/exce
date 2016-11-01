defmodule Exces.Mixfile do
  use Mix.Project

  def project do
    [app: :execs,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()]
  end

  def application do
    [applications: [:logger, :mnesia]]
  end

  defp deps do
    [{:qlc, "~> 1.0"}]
  end

  defp description do
    """
    Provides an interface for reading and writing data in an Entity Component System. Note that it is up to the
    consuming application to implement the 'Systems' as this package simply makes working with data easier. Uses Mnesia
    disc_copy tables.
    """
  end

  defp package do
    [
     name: :execs,
     files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Chris Hicks"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mononym/execs"}]
  end
end

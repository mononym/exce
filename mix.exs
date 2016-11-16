defmodule Execs.Mixfile do
  use Mix.Project

  def project do
    [app: :execs,
     version: "0.4.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()]
  end

  def application do
    [applications: [:mnesia],
     env: [ai_table_name: :ai_table,
           data_table_name: :data_table,
           db_client: Execs.DbClient.Mnesia]]
  end

  defp deps do
    [{:ex_doc, ">= 0.14.3", only: :dev},
     {:inch_ex, ">= 0.0.0", only: :docs},
     {:qlc, "~> 1.0"}]
  end

  defp description do
    """
    Provides an interface for reading and writing data in an Entity Component System. Note that it is up to the
    consuming application to implement the 'Systems' as this package simply makes working with data easier.
    """
  end

  defp package do
    [
     name: :execs,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Chris Hicks"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mononym/execs"}]
  end
end

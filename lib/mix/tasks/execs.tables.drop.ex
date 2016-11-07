defmodule Mix.Tasks.Execs.Tables.Drop do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Drop the tables for execs."

  @doc false
  def run(_) do
    IO.puts "Dropping tables"
    Application.ensure_started(:execs)
    Execs.drop_tables()
    IO.puts "Tables dropped"
  end
end

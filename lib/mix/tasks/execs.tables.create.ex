defmodule Mix.Tasks.Execs.Tables.Create do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Create the tables for execs."

  @doc false
  def run(_) do
    IO.puts "Creating tables"
    Application.ensure_started(:execs)
    Execs.create_tables()
    IO.puts "Tables created"
  end
end

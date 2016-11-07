defmodule Mix.Tasks.Execs.Setup do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Perform all database setup."

  @doc false
  def run(_) do
    IO.puts "Starting setup"
    Application.ensure_started(:execs)
    Mix.Task.run "execs.schema.create"
    Mix.Task.run "execs.tables.create"
    IO.puts "Finished setup"
  end
end

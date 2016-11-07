defmodule Mix.Tasks.Execs.Teardown do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Perform all database teardown."

  @doc false
  def run(_) do
    IO.puts "Starting teardown"
    Application.ensure_started(:execs)
    Mix.Task.run "execs.tables.drop"
    Mix.Task.run "execs.schema.delete"
    IO.puts "Finished teardown"
  end
end

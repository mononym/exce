defmodule Mix.Tasks.Execs.Schema.Delete do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Delete the schema/database for execs."

  @doc false
  def run(_) do
    IO.puts "Deleting schema"
    Application.ensure_started(:execs)
    Execs.delete_schema()
    IO.puts "Schema deleted"
  end
end

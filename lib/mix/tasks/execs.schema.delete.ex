defmodule Mix.Tasks.Execs.Schema.Delete do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Delete the schema for the database that execs is using"

  @doc false
  def run(_) do
    Application.ensure_started(:execs)
    Execs.delete_schema()
  end
end

defmodule Mix.Tasks.Execs.Schema.Create do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Create the schema the database that execs will use"

  @doc false
  def run(_) do
    Application.ensure_started(:execs)
    Execs.create_schema()
  end
end

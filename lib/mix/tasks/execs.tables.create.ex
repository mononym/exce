defmodule Mix.Tasks.Execs.Tables.Create do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Create the databases for execs usage"

  @doc false
  def run(_) do
    Application.ensure_started(:execs)
    Execs.create_tables()
  end
end

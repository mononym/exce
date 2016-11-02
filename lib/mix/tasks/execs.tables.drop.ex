defmodule Mix.Tasks.Execs.Tables.Drop do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Drop the databases that execs is using"

  @doc false
  def run(_) do
    Application.ensure_started(:execs)
    Execs.drop_tables()
  end
end

defmodule Mix.Tasks.Execs.Schema.Create do
  use Execs.Utils
  use Mix.Task

  @shortdoc "Create the schema/database execs will use."

  @doc false
  def run(_) do
    IO.puts "Creating schema"
    Application.ensure_started(:execs)
    Execs.create_schema()
    IO.puts "Schema created"
  end
end

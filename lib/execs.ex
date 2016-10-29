defmodule Execs do
  use Application

    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        worker(Execs.Initializer, [])
      ]

      opts = [strategy: :one_for_one, name: Execs.Supervisor]
      Supervisor.start_link(children, opts)
    end
end

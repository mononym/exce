defmodule Execs.Utils do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @doc false
      def cfg(key), do: Application.get_env(:execs, key)
    end
  end
end

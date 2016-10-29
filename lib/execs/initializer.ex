defmodule Execs.Initializer do
  @moduledoc false

  use GenServer

  @client Application.get_env(:execs, :client_module)

  def start_link(_, _) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    :ok = @client.initialize()
    {:ok, %{}}
  end
end

defmodule Execs.Initializer do
  @moduledoc false

  use GenServer

  def start_link(_, _) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    :ok = Execs.MnesiaClient.initialize()
    {:ok, %{}}
  end
end

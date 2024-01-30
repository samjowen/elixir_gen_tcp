defmodule GenTcp.Client do
  use GenServer

  def start_link(_) do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    init_arg = nil
    {:ok, init_arg}
  end
end

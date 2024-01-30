defmodule GenTcp.Server do
  # Always restart the Server if it crashes
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    init_state = nil
    {:ok, init_state}
  end
end

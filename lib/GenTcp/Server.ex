defmodule GenTcp.Server do
  require Logger
  # Always restart the Server if it crashes
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Logger.log(:debug, "Starting Server.")
    init_state = nil
    {:ok, init_state}
  end
end

defmodule GenTcp.Client do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    Logger.log(:debug, "Starting Client.")
    init_arg = nil
    {:ok, init_arg}
  end
end

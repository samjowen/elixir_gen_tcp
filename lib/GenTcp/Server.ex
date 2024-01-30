defmodule GenTcp.Server do

  # Always restart the Server if it crashes
  use GenServer, restart: :permanent

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end
end

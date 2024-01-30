defmodule GenTcp.Client do
  use GenServer


  def start_link(_) do
    GenServer.start(__MODULE__)
  end
end

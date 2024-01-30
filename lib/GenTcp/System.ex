defmodule GenTcp.System do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      {GenTcp.Server, nil}
    ]
  end
end

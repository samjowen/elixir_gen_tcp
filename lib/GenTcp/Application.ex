defmodule GenTcp.Application do
  use Application

  def start(_, _) do
    GenTcp.System.start_link()
  end
end

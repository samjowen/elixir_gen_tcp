defmodule GenTcp.Application do
  use Application

  def start(_type, _args) do
    GenTcp.System.start_link()
  end
end

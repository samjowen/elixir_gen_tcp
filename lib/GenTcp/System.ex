defmodule GenTcp.System do
  def start_link() do
    Supervisor.start_link(
      [
        {GenTcp.Server, GenTcp.Server.start_server()},
        {GenTcp.Client, nil}
      ],
      strategy: :one_for_one
    )
  end
end

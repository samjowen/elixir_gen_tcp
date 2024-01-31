defmodule GenTcp.System do
  def start_link() do
    Supervisor.start_link(
      [
        GenTcp.Server,
        GenTcp.Client
      ],
      strategy: :one_for_one
    )
  end
end

defmodule GenTcp.Server do
  require Logger
  # Always restart the Server if it crashes
  use GenServer

  @port 4000

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def handle_cast({:start_server}, listenSocket) do
    network_loop(listenSocket)
    {:noreply, nil}
  end

  def network_loop(listenSocket) do
    Logger.log(:debug, "Starting network loop.")
    {:ok, socket} = :gen_tcp.accept(listenSocket)
    serve(socket)
    network_loop(socket)
  end

  defp serve(socket) do
    Logger.log(:debug, "Serving socket...")

    socket
    |> get_client_packet()
    |> send_server_packet(socket)

    serve(socket)
  end

  defp get_client_packet(socket) do
    {:ok, packet} = :gen_tcp.recv(socket, 0)
    packet
  end

  defp send_server_packet(socket, packet) do
    Logger.log(:debug, "Sending packet to client...")
    :gen_tcp.send(socket, packet)
  end

  def init(_) do
    Logger.log(:debug, "Starting Server.")

    {:ok, socket} =
      :gen_tcp.listen(@port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.log(:info, "Server listening on port #{@port}.")

    {:ok, socket}
  end

  # Public function to start the server
  def start_server() do
    GenServer.cast(__MODULE__, {:start_server})
  end
end

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

    network_loop(listenSocket)
  end

  defp serve(socket) do
    Logger.log(:debug, "Serving socket...")

    socket
    |> get_client_packet()
    |> send_server_packet(socket)

    Logger.log(:debug, "#{__MODULE__}: Done serving, going again...")
  end

  defp get_client_packet(socket) do
    Logger.log(:debug, "#{__MODULE__}: Getting packet from client...")
    {:ok, packet} = :gen_tcp.recv(socket, 0)
    Logger.log(:debug, "#{__MODULE__}: Got packet from client: #{inspect(packet)}")
    packet
  end

  defp send_server_packet(packet, socket) do
    Logger.log(:debug, "#{__MODULE__}: Sending packet to client...")

    IO.inspect(packet)

    :ok =
      :gen_tcp.send(socket, packet)
  end

  def init(_) do
    Logger.log(:debug, "Starting Server.")

    {:ok, socket} =
      :gen_tcp.listen(@port, [:binary, packet: :raw, active: false, reuseaddr: true])

    Logger.log(:info, "Server listening on port #{@port}.")

    {:ok, socket}
  end

  # Public function to start the server
  def start_server() do
    GenServer.cast(__MODULE__, {:start_server})
  end
end

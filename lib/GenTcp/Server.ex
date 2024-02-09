defmodule GenTcp.Server do
  require Logger
  # Always restart the Server if it crashes
  use GenServer

  @port Application.compile_env(:echo_server, :tcp_listen_port)

  @impl true
  @spec init(:no_state) ::
          {:error, atom()} | {:ok, port() | {:"$inet", atom(), any()}, {:continue, :accept}}
  def init(:no_state) do
    Logger.log(:debug, "Starting Server.")

    case :gen_tcp.listen(@port, [
           :binary,
           packet: :raw,
           active: false,
           reuseaddr: true,
           recbuf: 2048
         ]) do
      {:ok, listenSocket} ->
        Logger.log(:info, "Server listening on port #{@port}.")
        {:ok, listenSocket, {:continue, :accept}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_state, name: __MODULE__)
  end

  @impl true
  def handle_continue(:accept, listenSocket) do
    {:ok, socket} = :gen_tcp.accept(listenSocket)

    Task.start(fn ->
      serve(socket)
    end)

    {:noreply, listenSocket, {:continue, :accept}}
  end

  defp serve(socket) do
    socket
    |> get_client_packet()
    |> send_server_packet(socket)

    # Close the socket
    # :ok = :gen_tcp.close(socket)
  end

  defp get_client_packet(socket) do
    {:ok, packet} = :gen_tcp.recv(socket, 0, 10_000)
    packet
  end

  defp send_server_packet(packet, socket) do
    :ok = :gen_tcp.send(socket, packet)
  end
end

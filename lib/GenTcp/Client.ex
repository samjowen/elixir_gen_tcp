defmodule GenTcp.Client do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Logger.log(:debug, "Starting Client.")
    init_arg = nil
    {:ok, init_arg}
  end

  def handle_call({:send_packet, message, url, port}, _from, state) do
    Logger.log(:debug, "Attempting to send packet.")

    {:ok, socket} =
      :gen_tcp.connect(url,
        port: port
      )

    Logger.log(:debug, "Socket made.")
    :ok = send_packet(socket, message)
    {:ok, data} = read_socket(socket)

    {:reply, data, state}
  end

  defp send_packet(socket, packet) do
    :gen_tcp.send(socket, packet)
  end

  defp read_socket(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    {:ok, data}
  end

  # End 'Private' interfaces

  # Public Interfaces
  def send_message(message) do
    GenServer.call(__MODULE__, {:send_packet, message, ~c"localhost", 4000})
  end
end

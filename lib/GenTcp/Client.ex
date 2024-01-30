defmodule GenTcp.Client do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Logger.log(:debug, "#{__MODULE__}: Starting Client.")
    init_arg = nil
    {:ok, init_arg}
  end

  def handle_call({:send_packet, message, hostname, port}, _from, state) do
    Logger.log(:debug, "#{__MODULE__}: Attempting to send packet.")
    # Be careful with packet: :line, it will not send the packet until a newline is sent
    opts = [:binary, :inet, active: false, packet: :line]

    {:ok, socket} =
      :gen_tcp.connect(hostname, port, opts)

    Logger.log(:debug, "#{__MODULE__}: Socket made: #{inspect(socket)}")
    :ok = send_packet(socket, message)
    {:ok, data} = read_socket(socket)
    Logger.log(:debug, "#{__MODULE__}: Data: #{inspect(data)}")
    {:reply, data, state}
  end

  defp send_packet(socket, packet) do
    Logger.log(:debug, "#{__MODULE__}: Sending packet to server...")
    :ok = :gen_tcp.send(socket, packet)
    Logger.log(:debug, "#{__MODULE__}: Packet sent to server.")
  end

  defp read_socket(socket) do
    Logger.log(:debug, "#{__MODULE__}: Reading socket data...")
    {:ok, data} = :gen_tcp.recv(socket, 0)
    {:ok, data}
  end

  # End 'Private' interfaces

  # Public Interfaces
  def send_message(message) do
    GenServer.call(__MODULE__, {:send_packet, message, :localhost, 4000})
  end
end

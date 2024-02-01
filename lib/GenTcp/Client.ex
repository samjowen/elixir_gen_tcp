defmodule GenTcp.Client do
  require Logger
  use GenServer

  @impl true
  def init({hostname, port}) do
    Logger.log(:debug, "#{__MODULE__}: Starting Client.")
    opts = [:binary, :inet, active: false, packet: :raw]

    case :gen_tcp.connect(hostname, port, opts) do
      {:ok, socket} ->
        {:ok, socket}

      {:error, reason} ->
        Logger.error(reason)
        {:error, reason}
    end
  end

  @impl true
  def handle_call({:send_packet, message}, _from, socket) do
    :ok = send_packet(socket, message)
    {:ok, data} = read_socket(socket)
    {:reply, data, socket}
  end

  @impl true
  def handle_cast({:send_packets, message, amount}, socket) do
    Enum.each(0..amount, fn _ -> Task.start(fn -> send_packet(socket, message) end) end)
    {:noreply, socket}
  end

  # End 'Private' interfaces

  # Private Helpers
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

  # Public Interfaces

  @spec start(binary(), integer()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start(hostname, port) when is_binary(hostname) and is_integer(port) do
    GenServer.start(__MODULE__, {hostname, port}, name: __MODULE__)
  end

  @spec send_message(binary()) :: any()
  def send_message(message) when is_binary(message) do
    GenServer.call(__MODULE__, {:send_packet, message, :localhost, 4000})
  end

  @spec send_messages(binary(), integer()) :: any()
  def send_messages(message, amount) when is_binary(message) and is_integer(amount) do
    GenServer.call(__MODULE__, {:send_packets, message, amount})
  end
end

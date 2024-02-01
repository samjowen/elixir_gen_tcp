defmodule GenTcp.Client do
  require Logger
  use GenServer

  @opts [:binary, :inet, active: false, packet: :raw]

  defstruct [:hostname, :port]

  @impl true
  def init(state) do
    Logger.log(:debug, "#{__MODULE__}: Starting Client.")

    {:ok, state}
  end

  @impl true
  def handle_call({:send_packet, message}, _from, state) do
    IO.inspect(state)
    {:ok, socket} = :gen_tcp.connect(String.to_charlist(state.hostname), state.port, @opts)
    :ok = send_packet(socket, message)
    {:ok, data} = read_socket(socket)
    :ok = :gen_tcp.close(socket)
    {:reply, data, state}
  end

  @impl true
  def handle_cast({:send_packets, message, amount}, state) do
    {:ok, socket} = :gen_tcp.connect(String.to_charlist(state.hostname), state.port, @opts)
    Logger.log(:debug, "Sending #{amount} packets.")
    tasks = Enum.map(0..amount, fn _ -> Task.async(fn -> send_packet(socket, message) end) end)

    Enum.each(tasks, &Task.await/1)
    Logger.log(:debug, "Finished sending #{amount} packets.")

    :ok = :gen_tcp.close(socket)
    {:noreply, state}
  end

  # End 'Private' interfaces

  # Private Helpers
  defp send_packet(socket, packet) do
    :ok = :gen_tcp.send(socket, packet)
    :ok
  end

  defp read_socket(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    {:ok, data}
  end

  # Public Interfaces

  def start(%GenTcp.Client{hostname: hostname, port: port}) do
    GenServer.start(__MODULE__, %GenTcp.Client{hostname: hostname, port: port}, name: __MODULE__)
  end

  @spec send_message(binary()) :: any()
  def send_message(message) when is_binary(message) do
    GenServer.call(__MODULE__, {:send_packet, message})
  end

  def send_messages(message, amount) when is_binary(message) and is_integer(amount) do
    GenServer.cast(__MODULE__, {:send_packets, message, amount})
  end
end

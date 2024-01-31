defmodule GenTcp.Test do
  use ExUnit.Case

  test "the system starts with the client and server" do
    assert Process.whereis(GenTcp.Client)
    assert Process.whereis(GenTcp.Server)
  end

  test "we can stop the server" do
    GenTcp.Server.stop()
  end
end

defmodule IrBeamWorker do
  use GenServer

  @ir_in 4

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, pid} = Gpio.start_link(@ir_in, :input)
    Gpio.set_int(pid, :both)
    {:ok, pid}
  end

  def handle_info(evt, state) do
    IO.inspect evt
    {:noreply, state}
  end
end

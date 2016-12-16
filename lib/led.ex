defmodule Led do
  use GenServer

  @led_out 17

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Gpio.start_link(@led_out, :output)
  end

  def handle_info(:turn_on, pid) do
    Gpio.write(pid, 1)
    {:noreply, pid}
  end

  def handle_info(:turn_off, pid) do
    Gpio.write(pid, 0)
    {:noreply, pid}
  end
end

defmodule IrBeamWorker do
  use GenServer

  @ir_in 4

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, pid} = Gpio.start_link(@ir_in, :input)
    Gpio.set_int(pid, :both)
    evt = case Gpio.read(pid) do
      1 ->
        build_event(:falling)
      0 ->
        build_event(:rising)
    end
    broadcast(evt)
    {:ok, :ignored}
  end

  def handle_info({:gpio_interrupt, @ir_in, edge}, state) do
    build_event(edge)
    |> broadcast
    {:noreply, state}
  end

  defp build_event(edge) do
    %{office: "london",
      timestamp: :calendar.universal_time(),
      action: action(edge)}
  end

  defp action(:falling), do: :open
  defp action(:rising), do: :close

  defp broadcast(evt) do
    try do
      IO.inspect evt
      GenEvent.notify(:collector, evt)
    rescue
      e -> IO.puts "Notify failed: #{inspect e}"
    end
  end
end

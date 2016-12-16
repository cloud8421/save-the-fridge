defmodule IrBeamWorker do
  use GenServer

  @ir_in 4

  @led_delay 2000

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
    case evt.action do
      :close ->
        ref = Process.send_after(Led, :turn_off, 0)
        {:ok, ref}
      :open  ->
        ref = Process.send_after(Led, :turn_on, 0)
        {:ok, ref}
    end
  end

  def handle_info({:gpio_interrupt, @ir_in, edge}, ref) do
    evt = build_event(edge)
    broadcast(evt)
    case evt.action do
      :open ->
        ref = Process.send_after(Led, :turn_on, @led_delay)
        {:noreply, ref}
      :close ->
        Process.cancel_timer(ref)
        new_ref = Process.send_after(Led, :turn_off, 0)
        {:noreply, new_ref}
    end
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

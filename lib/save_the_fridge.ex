defmodule SaveTheFridge do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Nerves.InterimWiFi.setup "wlan0", wifi_config()

    :fridge.start()

    # Define workers and child supervisors to be supervised
    children = [
      worker(Led, []),
      worker(IrBeamWorker, [])
      # worker(SaveTheFridge.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SaveTheFridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp wifi_config do
    Application.get_env(:save_the_fridge, :wifi)
  end
end

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :nerves_interim_wifi,
  regulatory_domain: "US"

config :save_the_fridge, :wifi,
  ssid: "Claudio's Macbook Pro",
  key_mgmt: :"NONE"
  # psk: System.get_env("WIFI_PSK")

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

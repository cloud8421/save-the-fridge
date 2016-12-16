defmodule SaveTheFridge.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :save_the_fridge,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],

     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {SaveTheFridge, []},
     applications: [:logger, :elixir_ale, :nerves_interim_wifi]]
  end

  def deps do
    [{:nerves, "~> 0.3.4"},
     {:elixir_ale, "~> 0.5.5"},
     {:nerves_interim_wifi, "~> 0.1.0"}]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end

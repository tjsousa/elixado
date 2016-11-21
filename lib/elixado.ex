defmodule Elixado do
  use GenServer

  @envoy_executable '/envoy'
  @config_path ''

  defstruct port: nil

  def start_link(config_path \\ @config_path) do
    GenServer.start_link(__MODULE__, {@envoy_executable, config_path})
  end

  def init({executable, config}) do
    envoy = :code.priv_dir(:elixado) ++ executable

    Process.register(self, :elixado)
    Process.flag(:trap_exit, true)

    port = Port.open(
      {:spawn_executable, envoy},
      [{:args, ["-c", config]},
       :exit_status])

    {:ok, %Elixado{port: port} }
  end

  def handle_info({_, {:exit_status, _}}, state) do
    {:stop, :unexpected_exit, state}
  end
end

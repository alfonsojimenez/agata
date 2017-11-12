defmodule Agata do
  use Application
  require Logger

  def start(_, _) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Agata.Router, [], [
        port: Application.get_env(:agata, :http_port),
        dispatch: dispatch()
      ]),
      worker(:gen_smtp_server, [Agata.MailServer, [[
        address: Application.get_env(:agata, :smtp_address),
        port: Application.get_env(:agata, :smtp_port)
      ]]]),
      worker(Agata.Clients, [[name: Agata.Clients]]),
      worker(Agata.Storage, [[name: Agata.Storage]]),
      supervisor(Task.Supervisor, [[name: :email_sup]])
    ]

    Logger.info "Starting Àgata"
    Logger.info "==> smpt://127.0.0.1:#{Application.get_env(:agata, :smtp_port)}"
    Logger.info "==> http://127.0.0.1:#{Application.get_env(:agata, :http_port)}"

    opts = [strategy: :one_for_one, name: Agata.Supervisor]

    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_, [
        {"/ws", Agata.SocketHandler, []},
        {:_, Plug.Adapters.Cowboy.Handler, {Agata.Router, []}}
      ]}
    ]
  end
end

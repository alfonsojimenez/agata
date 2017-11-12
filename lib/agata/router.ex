defmodule Agata.Router do
  use Plug.Router

  plug Plug.Static, at: "/public", from: :agata
  plug Plug.Static, at: "/tmp", from: "priv/tmp"

  plug :match
  plug :dispatch

  get "/", do: send_resp(
    conn, 200, EEx.eval_file("views/index.eex", [emails: Agata.Storage.to_json])
  )

  match _, do: send_resp(conn, 404, "Not Found")
end

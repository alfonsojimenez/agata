use Mix.Config

config :agata, smtp_address: {127, 0, 0, 1}
config :agata, smtp_port: 1025
config :agata, http_port: 8080
config :agata, web_socket_timeout: 600000

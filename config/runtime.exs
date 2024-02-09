import Config

config :echo_server,
  tcp_listen_port: 4000

import_config "#{config_env()}.exs"

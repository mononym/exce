use Mix.Config

# Print only warnings and errors during test
config :logger, level: :debug

config :execs,
  purge_on_start: true

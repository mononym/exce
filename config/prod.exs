use Mix.Config

config :logger,
  compile_time_purge_level: :info

config :execs,
  data_table_name: :data_prod,
  entity_table_name: :entity_prod

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"

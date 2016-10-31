defmodule Execs do
  use Application

  @client Application.get_env(:execs, :client_module)


  #
  # Application callback
  #


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Execs.Initializer, [])
    ]

    opts = [strategy: :one_for_one, name: Execs.Supervisor]
    Supervisor.start_link(children, opts)
  end


  #
  # Application API
  #


  def initialize, do: @client.initialize()

  def transaction(block), do: @client.transaction(block)

  # create

  def create, do: hd(create(1))
  def create(n), do: @client.create(n)


  # delete

  def delete(ids) when is_list(ids), do: @client.delete(ids)
  def delete(id), do: hd(delete([id]))

  def delete(ids, components) when is_list(ids) do
    @client.delete(ids, enforce_list(components))
  end

  def delete(id, components) do
    hd(delete([id], components))
  end

  def delete(ids, components, keys) when is_list(ids) do
    @client.delete(ids, enforce_list(components), enforce_list(keys))
  end

  def delete(id, components, keys) do
    hd(delete([id], components, keys))
  end


  # has_all

  def has_all(ids, components) when is_list(ids) do
    @client.has_all(ids, enforce_list(components))
  end

  def has_all(id, components), do: hd(has_all([id], components))

  def has_all(ids, components, keys) when is_list(ids) do
    @client.has_all(ids, enforce_list(components), enforce_list(keys))
  end

  def has_all(id, components, keys), do: hd(has_all([id], components, keys))

  def has_all(ids, components, keys, functions) when is_list(ids) do
    @client.has_all(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_all(id, components, keys, functions) do
    hd(has_all([id], components, keys, functions))
  end


  # has_any

  def has_any(ids, components) when is_list(ids) do
    @client.has_any(ids, enforce_list(components))
  end

  def has_any(id, components), do: hd(has_any([id], components))

  def has_any(ids, components, keys) when is_list(ids) do
    @client.has_any(ids, enforce_list(components), enforce_list(keys))
  end

  def has_any(id, components, keys), do: hd(has_any([id], components, keys))

  def has_any(ids, components, keys, functions) when is_list(ids) do
    @client.has_any(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_any(id, components, keys, functions) do
    hd(has_any([id], components, keys, functions))
  end


  # has_which

  def has_which(ids, components) when is_list(ids) do
    @client.has_which(ids, enforce_list(components))
  end

  def has_which(id, components), do: hd(has_which([id], components))

  def has_which(ids, components, keys) when is_list(ids) do
    @client.has_which(ids, enforce_list(components), enforce_list(keys))
  end

  def has_which(id, components, keys), do: hd(has_which([id], components, keys))

  def has_which(ids, components, keys, functions) when is_list(ids) do
    @client.has_which(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_which(id, components, keys, functions) do
    hd(has_which([id], components, keys, functions))
  end


  # list

  def list(ids) when is_list(ids), do: @client.list(ids)
  def list(id), do: hd(list([id]))

  def list(ids, components) when is_list(ids) do
    @client.list(ids, enforce_list(components))
  end

  def list(id, components), do: hd(list([id], components))


  # find_with_all

  def find_with_all(components) do
    @client.find_with_all(components)
  end

  def find_with_all(components, keys) do
    @client.find_with_all(components, keys)
  end

  def find_with_all(components, keys, functions) do
    @client.find_with_all(components, keys, functions)
  end


  # find_with_any

  def find_with_any(components) do
    @client.find_with_any(components)
  end

  def find_with_any(components, keys) do
    @client.find_with_any(components, keys)
  end

  def find_with_any(components, keys, functions) do
    @client.find_with_any(components, keys, functions)
  end


  # read

  def read(ids) when is_list(ids), do: @client.read(ids)
  def read(id), do: hd(read([id]))

  def read(ids, components) when is_list(ids) do
    @client.read(ids, enforce_list(components))
  end

  def read(id, components), do: hd(read([id], components))

  def read(ids, components, keys) when is_list(ids) do
    @client.read(ids, enforce_list(components), enforce_list(keys))
  end

  def read(id, components, keys), do: hd(read([id], components, keys))


  # write

  def write(ids, components, keys, value) when is_list(ids) do
    @client.write(ids, enforce_list(components), enforce_list(keys), value)
  end

  def write(id, components, keys, value) do
    hd(write([id], components, keys, value))
  end


  #
  # Private functions
  #


  defp enforce_list(value) when is_list(value), do: value
  defp enforce_list(value), do: [value]
end

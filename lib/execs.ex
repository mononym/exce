defmodule Execs do
  alias Execs.MnesiaClient, as: MC


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


  def initialize, do: MC.initialize()

  def transaction(block), do: MC.transaction(block)

  # create

  def create, do: hd(create(1))
  def create(n), do: MC.create(n)


  # delete

  def delete(ids) when is_list(ids), do: MC.delete(ids)
  def delete(id), do: hd(delete([id]))

  def delete(ids, components) when is_list(ids) do
    MC.delete(ids, enforce_list(components))
  end

  def delete(id, components) do
    hd(delete([id], components))
  end

  def delete(ids, components, keys) when is_list(ids) do
    MC.delete(ids, enforce_list(components), enforce_list(keys))
  end

  def delete(id, components, keys) do
    hd(delete([id], components, keys))
  end


  # has_all

  def has_all(ids, components) when is_list(ids) do
    MC.has_all(ids, enforce_list(components))
  end

  def has_all(id, components), do: hd(has_all([id], components))

  def has_all(ids, components, keys) when is_list(ids) do
    MC.has_all(ids, enforce_list(components), enforce_list(keys))
  end

  def has_all(id, components, keys), do: hd(has_all([id], components, keys))

  def has_all(ids, components, keys, functions) when is_list(ids) do
    MC.has_all(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_all(id, components, keys, functions) do
    hd(has_all([id], components, keys, functions))
  end


  # has_any

  def has_any(ids, components) when is_list(ids) do
    MC.has_any(ids, enforce_list(components))
  end

  def has_any(id, components), do: hd(has_any([id], components))

  def has_any(ids, components, keys) when is_list(ids) do
    MC.has_any(ids, enforce_list(components), enforce_list(keys))
  end

  def has_any(id, components, keys), do: hd(has_any([id], components, keys))

  def has_any(ids, components, keys, functions) when is_list(ids) do
    MC.has_any(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_any(id, components, keys, functions) do
    hd(has_any([id], components, keys, functions))
  end


  # has_which

  def has_which(ids, components) when is_list(ids) do
    MC.has_which(ids, enforce_list(components))
  end

  def has_which(id, components), do: hd(has_which([id], components))

  def has_which(ids, components, keys) when is_list(ids) do
    MC.has_which(ids, enforce_list(components), enforce_list(keys))
  end

  def has_which(id, components, keys), do: hd(has_which([id], components, keys))

  def has_which(ids, components, keys, functions) when is_list(ids) do
    MC.has_which(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_which(id, components, keys, functions) do
    hd(has_which([id], components, keys, functions))
  end


  # list

  def list(ids) when is_list(ids), do: MC.list(ids)
  def list(id), do: hd(list([id]))

  def list(ids, components) when is_list(ids) do
    MC.list(ids, enforce_list(components))
  end

  def list(id, components), do: hd(list([id], components))


  # find_with_all

  def find_with_all(components) do
    MC.find_with_all(enforce_list(components))
  end

  def find_with_all(components, keys) do
    MC.find_with_all(enforce_list(components), enforce_list(keys))
  end

  def find_with_all(components, keys, functions) do
    MC.find_with_all(enforce_list(components),
                     enforce_list(keys),
                     enforce_list(functions))
  end


  # find_with_any

  def find_with_any(components) do
    MC.find_with_any(enforce_list(components))
  end

  def find_with_any(components, keys) do
    MC.find_with_any(enforce_list(components), enforce_list(keys))
  end

  def find_with_any(components, keys, functions) do
    MC.find_with_any(enforce_list(components), enforce_list(keys), enforce_list(functions))
  end


  # read

  def read(ids) when is_list(ids), do: MC.read(ids)
  def read(id), do: hd(read([id]))

  def read(ids, components) when is_list(ids) do
    MC.read(ids, enforce_list(components))
  end

  def read(id, components), do: hd(read([id], components))

  def read(ids, components, keys) when is_list(ids) do
    MC.read(ids, enforce_list(components), enforce_list(keys))
  end

  def read(id, components, keys), do: hd(read([id], components, keys))


  # write

  def write(ids, components, keys, value) when is_list(ids) do
    MC.write(ids, enforce_list(components), enforce_list(keys), value)
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

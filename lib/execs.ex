defmodule Execs do
  @moduledoc """
  Execs provides the data abstraction layer for an Entity-Component System. It
  uses a Mnesia client by default, with disc_copy tables. There is currently
  no other client though the framework is in place for one should the need
  arise.

  All clients must implement the Execs.DbClient.Client behavior.
  """
  use Execs.Utils


  #
  # Mix tasks
  #


  @doc false
  def create_schema do
    client().create_schema()
  end

  @doc false
  def delete_schema do
    client().delete_schema()
  end

  @doc false
  def create_tables do
    client().create_tables()
  end

  @doc false
  def drop_tables do
    client().drop_tables()
  end


  #
  # Application API
  #


  @doc """
  All data manipulation functions expect to be performed in the context of a
  transaction. This ensures all systems can run concurrently while safely
  accessing data.
  """
  def transaction(block), do: client().transaction(block)

  @doc """
  Create a single entity and return the id.
  """
  def create, do: hd(create(1))

  @doc """
  Create the specified number of entities and return their ids.
  """
  def create(n), do: client().create(n)

  @doc """
  Delete a set of entities and all their data.
  """
  def delete(ids) when is_list(ids), do: client().delete(ids)
  def delete(id), do: hd(delete([id]))

  @doc """
  Delete a set of components and all their data from a set of entities.
  """
  def delete(ids, components) when is_list(ids) do
    client().delete(ids, enforce_list(components))
  end

  def delete(id, components) do
    hd(delete([id], components))
  end

  @doc """
  Delete a set of keys from a set of components which belong to a set of entities.
  """
  def delete(ids, components, keys) when is_list(ids) do
    client().delete(ids, enforce_list(components), enforce_list(keys))
  end

  def delete(id, components, keys) do
    hd(delete([id], components, keys))
  end

  @doc """
  Check to see if a set of entities has a set of components.
  """
  def has_all(ids, components) when is_list(ids) do
    client().has_all(ids, enforce_list(components))
  end

  def has_all(id, components), do: hd(has_all([id], components))

  @doc """
  Check to see if a set of entities has set of keys.
  """
  def has_all(ids, components, keys) when is_list(ids) do
    client().has_all(ids, enforce_list(components), enforce_list(keys))
  end

  def has_all(id, components, keys), do: hd(has_all([id], components, keys))

  @doc """
  Check to see if a set of entities has set of keys. The value associated with the each key
  is passed to each of the comparison functions. If all functions return true then there is
  a match.
  """
  def has_all(ids, components, keys, functions) when is_list(ids) do
    client().has_all(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_all(id, components, keys, functions) do
    hd(has_all([id], components, keys, functions))
  end

  @doc """
  Check to see if a set of entities has at least one of a set of components.
  """
  def has_any(ids, components) when is_list(ids) do
    client().has_any(ids, enforce_list(components))
  end

  def has_any(id, components), do: hd(has_any([id], components))

  @doc """
  Check to see if a set of entities has at least one of a set of keys.
  """
  def has_any(ids, components, keys) when is_list(ids) do
    client().has_any(ids, enforce_list(components), enforce_list(keys))
  end

  def has_any(id, components, keys), do: hd(has_any([id], components, keys))

  @doc """
  Check to see if a set of entities has at least one of a set of keys. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  def has_any(ids, components, keys, functions) when is_list(ids) do
    client().has_any(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_any(id, components, keys, functions) do
    hd(has_any([id], components, keys, functions))
  end

  @doc """
  Check to see which of a set of components a set of entities has.
  """
  def has_which(ids, components) when is_list(ids) do
    client().has_which(ids, enforce_list(components))
  end

  def has_which(id, components), do: hd(has_which([id], components))

  @doc """
  Check to see which of a set of keys a set of entities has.
  """
  def has_which(ids, components, keys) when is_list(ids) do
    client().has_which(ids, enforce_list(components), enforce_list(keys))
  end

  def has_which(id, components, keys), do: hd(has_which([id], components, keys))

  @doc """
  Check to see which of a set of keys a set of entities has. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  def has_which(ids, components, keys, functions) when is_list(ids) do
    client().has_which(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_which(id, components, keys, functions) do
    hd(has_which([id], components, keys, functions))
  end

  @doc """
  List the components of a set of entities.
  """
  def list(ids) when is_list(ids), do: client().list(ids)

  def list(id), do: hd(list([id]))

  @doc """
  List the keys belonging to a set of components of a set of entities.
  """
  def list(ids, components) when is_list(ids) do
    client().list(ids, enforce_list(components))
  end

  def list(id, components), do: hd(list([id], components))

  @doc """
  List the entities which have a set of components.
  """
  def find_with_all(components) do
    client().find_with_all(enforce_list(components))
  end

  @doc """
  List the entities which have a set of keys.
  """
  def find_with_all(components, keys) do
    client().find_with_all(enforce_list(components), enforce_list(keys))
  end

  @doc """
  List the entities which have a set of keys. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  def find_with_all(components, keys, functions) do
    client().find_with_all(enforce_list(components),
                     enforce_list(keys),
                     enforce_list(functions))
  end

  @doc """
  List the entities which have at least one of a set of components.
  """
  def find_with_any(components) do
    client().find_with_any(enforce_list(components))
  end

  @doc """
  List the entities which have at least one of a set of keys.
  """
  def find_with_any(components, keys) do
    client().find_with_any(enforce_list(components), enforce_list(keys))
  end

  @doc """
  List the entities which have at least one of a set of keys. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  def find_with_any(components, keys, functions) do
    client().find_with_any(enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  @doc """
  Read a set of entities.
  """
  def read(ids) when is_list(ids), do: client().read(ids)

  def read(id), do: hd(read([id]))

  @doc """
  Read a set of components belonging to a set of entities.
  """
  def read(ids, components) when is_list(ids) do
    client().read(ids, enforce_list(components))
  end

  def read(id, components), do: hd(read([id], components))

  @doc """
  Read a set of keys belonging to a set of entities.
  """
  def read(ids, components, keys) when is_list(ids) do
    client().read(ids, enforce_list(components), enforce_list(keys))
  end

  def read(id, components, keys), do: hd(read([id], components, keys))

  @doc """
  Write a value to any combination of keys, components, and entities.
  """
  def write(ids, components, keys, value) when is_list(ids) do
    client().write(ids, enforce_list(components), enforce_list(keys), value)
  end

  def write(id, components, keys, value) do
    hd(write([id], components, keys, value))
  end


  #
  # Private functions
  #

  defp client, do: cfg(:db_client)


  defp enforce_list(value) when is_list(value), do: value
  defp enforce_list(value), do: [value]
end

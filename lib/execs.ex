defmodule Execs do
  @moduledoc """
  Execs provides the data abstraction layer for an Entity-Component System. It
  uses a Mnesia client by default, with disc_copy tables. There is currently
  no other client though the framework is in place for one should the need
  arise.

  All clients must implement the Execs.DbClient.Client behavior.
  """
  use Execs.Utils

  @opaque id :: integer()
  @type component :: atom()
  @type component_list :: [component]
  @type component_match :: %{id: id, components: %{component => boolean()}}
  @type component_match_list :: [component_match]
  @type entity :: %{id: id, components: %{component => kv_pairs}}
  @type entity_list :: [entity]
  @type key :: any()
  @type key_match :: %{id: id, components: %{component => %{key => boolean()}}}
  @type key_match_list :: [key_match]
  @type kv_pairs :: map()
  @type id_list :: [id]
  @type id_match :: %{id: id, result: boolean()}
  @type id_match_list :: [id_match]
  @type fun_list :: [fun()]
  @type key_list :: [key]
  @type list_keys :: %{id: id, components: %{component => [key]}}
  @type list_keys_list :: [list_keys]
  @type list_components :: %{id: id, components: maybe_component_list}
  @type list_components_list :: [list_components]
  @type maybe_component_list :: component | component_list
  @type maybe_component_match_list :: component_match | component_match_list
  @type maybe_entity_list :: entity | entity_list
  @type maybe_fun_list :: fun | fun_list
  @type maybe_id_list :: id | id_list
  @type maybe_id_match_list :: id_match | id_match_list
  @type maybe_key_list :: key | key_list
  @type maybe_key_match_list :: key_match | key_match_list
  @type maybe_list_components_list :: list_components | list_components_list
  @type maybe_list_keys_list :: list_keys | list_keys_list


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
  @spec transaction(fun()) :: any()
  def transaction(block), do: client().transaction(block)

  @doc """
  Create a single entity and return the id.
  """
  @spec create() :: id
  def create, do: hd(create(1))

  @doc """
  Create the specified number of entities and return their ids.
  """
  @spec create(integer()) :: id_list
  def create(n), do: client().create(n)

  @doc """
  Delete a set of entities and all their data.
  """
  @spec delete(maybe_id_list) :: maybe_entity_list
  def delete(ids) when is_list(ids), do: client().delete(ids)
  def delete(id), do: hd(delete([id]))

  @doc """
  Delete a set of components and all their data from a set of entities.
  """
  @spec delete(maybe_id_list, maybe_component_list) :: maybe_entity_list
  def delete(ids, components) when is_list(ids) do
    client().delete(ids, enforce_list(components))
  end

  def delete(id, components) do
    hd(delete([id], components))
  end

  @doc """
  Delete a set of keys from a set of components which belong to a set of entities.
  """
  @spec delete(maybe_id_list, maybe_component_list, maybe_key_list) :: maybe_entity_list
  def delete(ids, components, keys) when is_list(ids) do
    client().delete(ids, enforce_list(components), enforce_list(keys))
  end

  def delete(id, components, keys) do
    hd(delete([id], components, keys))
  end

  @doc """
  Check to see if a set of entities has a set of components.
  """
  @spec has_all(maybe_id_list, maybe_component_list) :: maybe_id_match_list
  def has_all(ids, components) when is_list(ids) do
    client().has_all(ids, enforce_list(components))
  end

  def has_all(id, components), do: hd(has_all([id], components))

  @doc """
  Check to see if a set of entities has set of keys.
  """
  @spec has_all(maybe_id_list, maybe_component_list, maybe_key_list) :: maybe_id_match_list
  def has_all(ids, components, keys) when is_list(ids) do
    client().has_all(ids, enforce_list(components), enforce_list(keys))
  end

  def has_all(id, components, keys), do: hd(has_all([id], components, keys))

  @doc """
  Check to see if a set of entities has set of keys. The value associated with the each key
  is passed to each of the comparison functions. If all functions return true then there is
  a match.
  """
  @spec has_all(maybe_id_list, maybe_component_list, maybe_key_list, maybe_fun_list) :: maybe_id_match_list
  def has_all(ids, components, keys, functions) when is_list(ids) do
    client().has_all(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_all(id, components, keys, functions) do
    hd(has_all([id], components, keys, functions))
  end

  @doc """
  Check to see if a set of entities has at least one of a set of components.
  """
  @spec has_any(maybe_id_list, maybe_component_list) :: maybe_id_match_list
  def has_any(ids, components) when is_list(ids) do
    client().has_any(ids, enforce_list(components))
  end

  def has_any(id, components), do: hd(has_any([id], components))

  @doc """
  Check to see if a set of entities has at least one of a set of keys.
  """
  @spec has_any(maybe_id_list, maybe_component_list, maybe_key_list) :: maybe_id_match_list
  def has_any(ids, components, keys) when is_list(ids) do
    client().has_any(ids, enforce_list(components), enforce_list(keys))
  end

  def has_any(id, components, keys), do: hd(has_any([id], components, keys))

  @doc """
  Check to see if a set of entities has at least one of a set of keys. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  @spec has_any(maybe_id_list, maybe_component_list, maybe_key_list, maybe_fun_list) :: maybe_id_match_list
  def has_any(ids, components, keys, functions) when is_list(ids) do
    client().has_any(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_any(id, components, keys, functions) do
    hd(has_any([id], components, keys, functions))
  end

  @doc """
  Check to see which of a set of components a set of entities has.
  """
  @spec has_which(maybe_id_list, maybe_component_list) :: maybe_component_match_list
  def has_which(ids, components) when is_list(ids) do
    client().has_which(ids, enforce_list(components))
  end

  def has_which(id, components), do: hd(has_which([id], components))

  @doc """
  Check to see which of a set of keys a set of entities has.
  """
  @spec has_which(maybe_id_list, maybe_component_list, maybe_key_list) ::maybe_component_match_list
  def has_which(ids, components, keys) when is_list(ids) do
    client().has_which(ids, enforce_list(components), enforce_list(keys))
  end

  def has_which(id, components, keys), do: hd(has_which([id], components, keys))

  @doc """
  Check to see which of a set of keys a set of entities has. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  @spec has_which(maybe_id_list, maybe_component_list, maybe_key_list, maybe_fun_list) :: maybe_component_match_list
  def has_which(ids, components, keys, functions) when is_list(ids) do
    client().has_which(ids, enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  def has_which(id, components, keys, functions) do
    hd(has_which([id], components, keys, functions))
  end

  @doc """
  List the components of a set of entities.
  """
  @spec list(maybe_id_list) :: maybe_list_components_list
  def list(ids) when is_list(ids), do: client().list(ids)

  def list(id), do: hd(list([id]))

  @doc """
  List the keys belonging to a set of components of a set of entities.
  """
  @spec list(maybe_id_list, maybe_component_list) :: maybe_list_keys_list
  def list(ids, components) when is_list(ids) do
    client().list(ids, enforce_list(components))
  end

  def list(id, components), do: hd(list([id], components))

  @doc """
  List the entities which have a set of components.
  """
  @spec find_with_all(maybe_component_list) :: id_list
  def find_with_all(components) do
    client().find_with_all(enforce_list(components))
  end

  @doc """
  List the entities which have a set of keys.
  """
  @spec find_with_all(maybe_component_list, maybe_key_list) :: id_list
  def find_with_all(components, keys) do
    client().find_with_all(enforce_list(components), enforce_list(keys))
  end

  @doc """
  List the entities which have a set of keys. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  @spec find_with_all(maybe_component_list, maybe_key_list, maybe_fun_list) :: id_list
  def find_with_all(components, keys, functions) do
    client().find_with_all(enforce_list(components),
                     enforce_list(keys),
                     enforce_list(functions))
  end

  @doc """
  List the entities which have at least one of a set of components.
  """
  @spec find_with_any(maybe_component_list) :: id_list
  def find_with_any(components) do
    client().find_with_any(enforce_list(components))
  end

  @doc """
  List the entities which have at least one of a set of keys.
  """
  @spec find_with_any(maybe_component_list, maybe_key_list) :: id_list
  def find_with_any(components, keys) do
    client().find_with_any(enforce_list(components), enforce_list(keys))
  end

  @doc """
  List the entities which have at least one of a set of keys. The value associated
  with the each key is passed to each of the comparison functions. If all functions return
  true then there is a match.
  """
  @spec find_with_any(maybe_component_list, maybe_key_list, maybe_fun_list) :: id_list
  def find_with_any(components, keys, functions) do
    client().find_with_any(enforce_list(components), enforce_list(keys), enforce_list(functions))
  end

  @doc """
  Read a set of entities.
  """
  @spec read(maybe_id_list) :: maybe_entity_list
  def read(ids) when is_list(ids), do: client().read(ids)

  def read(id), do: hd(read([id]))

  @doc """
  Read a set of components belonging to a set of entities.
  """
  @spec read(maybe_id_list, maybe_component_list) :: maybe_entity_list
  def read(ids, components) when is_list(ids) do
    client().read(ids, enforce_list(components))
  end

  def read(id, components), do: hd(read([id], components))

  @doc """
  Read a set of keys belonging to a set of entities. Providing anything other
  than a single id, component, and key will return a map otherwise a single
  value is returned.
  """
  @spec read(maybe_id_list, maybe_component_list, maybe_key_list) :: maybe_entity_list | any()
  def read(ids, components, keys) when is_list(ids) do
    client().read(ids, enforce_list(components), enforce_list(keys))
  end

  def read(id, component, key)
      when is_list(component) == false
      and is_list(key) == false do
    entity = hd(read([id], component, key))
    entity[:components][component][key]
  end

  def read(id, components, keys), do: hd(read([id], components, keys))

  @doc """
  Write a value to any combination of keys, components, and entities.
  """
  @spec write(maybe_id_list, maybe_component_list, maybe_key_list, any()) :: maybe_id_list
  def write(ids, components, keys, value) when is_list(ids) do
    client().write(ids, enforce_list(components), enforce_list(keys), value)
  end

  def write(id, components, keys, value) do
    hd(write([id], components, keys, value))
  end


  #
  # Private functions
  #

  @spec client() :: any()
  defp client, do: cfg(:db_client)


  @spec enforce_list(list(any())) :: list(any())
  defp enforce_list(value) when is_list(value), do: value

  @spec enforce_list(any()) :: list(any())
  defp enforce_list(value), do: [value]
end

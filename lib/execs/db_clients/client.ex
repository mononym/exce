defmodule Execs.DbClient.Client do
  @moduledoc """
  Data manipulation is handled through clients which implement this interface.
  """

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
  @type list_components :: %{id: id, components: component_list}
  @type list_components_list :: [list_components]

  @doc """
  Setup the schema for the database.
  """
  @callback create_schema() :: any()

  @doc """
  Delete the schema for the database.
  """
  @callback create_schema() :: any()

  @doc """
  Create the tables for the database.
  """
  @callback create_tables() :: any()

  @doc """
  Drop the tables for the database.
  """
  @callback drop_tables() :: any()

  @doc """
  Take a function and execute it in the context of a transaction.
  """
  @callback transaction(fun()) :: any()

  @doc """
  Create the specified number of entities and returns the ids.
  """
  @callback create(total :: integer()) :: id_list

  @doc """
  Delete an entity and all its data.
  """
  @callback delete(id_list) :: entity_list

  @doc """
  Delete a component and all its data from an entity.
  """
  @callback delete(id_list, component_list) :: entity_list

  @doc """
  Delete a key from a component of an entity.
  """
  @callback delete(id_list,
                   component_list,
                   key_list) :: entity_list

  @doc """
  Check to see if one or more entities have a component or set of components.
  """
  @callback has_all(id_list, component_list) :: id_match_list

  @doc """
  Check to see if one or more entities have a key or set of keys..
  """
  @callback has_all(id_list,
                 component_list,
                 key_list) :: id_match_list

  @doc """
  Check to see if one or more entities have a value. This is determined by
  passing the value associated with the provided id to the passed in filter
  function and evaluating the boolean result.
  """
  @callback has_all(id_list,
                component_list,
                key_list,
                fun_list) :: id_match_list

  @doc """
  Check to see if one or more entities have a component or set of components.
  """
  @callback has_any(id_list, component_list) :: id_match_list

  @doc """
  Check to see if one or more entities have a key or set of keys.
  """
  @callback has_any(id_list,
                 component_list,
                 key_list) :: id_match_list

  @doc """
  Check to see if one or more entities have a value. This is determined by
  passing the value associated with the provided id to the passed in filter
  function and evaluating the boolean result.
  """
  @callback has_any(id_list,
                component_list,
                key_list,
                fun_list) :: id_match_list

  @doc """
  Check to see if one or more entities have a component or set of components.

  Returns a map of the results.
  """
  @callback has_which(id_list, component_list) :: component_match_list

  @doc """
  Check to see if one or more entities have a key or set of keys.

  Returns a map of the results.
  """
  @callback has_which(id_list,
                     component_list,
                     key_list) :: key_match_list

  @doc """
  Check to see if one or more entities have a value. This is determined by
  passing the value associated with the provided id to the passed in filter
  function and evaluating the boolean result.
  """
  @callback has_which(id_list,
                     component_list,
                     key_list,
                     fun_list) :: key_match_list

  @doc """
  List the components of an entity.
  """
  @callback list(id_list) :: list_components_list

  @doc """
  List the keys belonging to a component of an entity.
  """
  @callback list(id_list, component_list) :: list_keys_list

  @doc """
  List the entities which have a component or a set of components.
  """
  @callback find_with_all(component_list) :: id_list

  @doc """
  List the entities which have a key or set of keys.
  """
  @callback find_with_all(component_list, key_list) :: id_list

  @doc """
  List the entities which have certain values. This is determined by passing
  the value to the passed in filter function and evaluating the boolean result.

  A `true` result means that the entity which has that particular value will be
  included in the results.
  """
  @callback find_with_all(component_list,
                  key_list,
                  fun_list) :: id_list

  @doc """
  List the entities which have at least one of a set of components.
  """
  @callback find_with_any(component_list) :: id_list

  @doc """
  List the entities which have at least one of set of keys.
  """
  @callback find_with_any(component_list, key_list) :: id_list

  @doc """
  List the entities which have at least one of a set of certain values. This
  is determined by passing the value to the passed in filter function and
  evaluating the boolean result.

  A `true` result means that the entity which has that particular value will be
  included in the results.
  """
  @callback find_with_any(component_list,
                  key_list,
                  fun_list) :: id_list

  @doc """
  Read an entity or set of entities.
  """
  @callback read(id_list) :: entity_list

  @doc """
  Read a component or set of component from an entity or set of entities.
  """
  @callback read(id_list, component_list) :: entity_list

  @doc """
  Read a key or set of keys from an entity or set of entities.
  """
  @callback read(id_list,
                 component_list,
                 key_list) :: entity_list

  @doc """
  Write a value to any combination of ids, components, and entities.
  """
  @callback write(id_list,
                  component_list,
                  key_list,
                  any()) :: id_list
end

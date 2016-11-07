# Execs

[![Build Status](https://travis-ci.org/mononym/execs.svg?branch=master)](https://travis-ci.org/mononym/execs)
[![Hex.pm Version](http://img.shields.io/hexpm/v/execs.svg?style=flat)](https://hex.pm/packages/execs)
[![Inline docs](http://inch-ci.org/github/mononym/execs.svg)](http://inch-ci.org/github/mononym/execs)

Elixir Entity Component System. Abstracts away the mechanisms used to store, lookup, and retrieve data in an Entity-Component System.

Note that this application only provides the mechanisms for working with data and expects the consuming application to provide the "System" part of the equation.

**WARNING**: This software is new and has been minimally tested.

## Including as Dependency

```elixir
defp deps do
  [{:execs, "~> 0.3.0"}]
end
```

## Managing database

There are six mix tasks provided as hooks for managing the lifecycle of the database:
* execs.schema.create
* execs.schema.delete
* execs.tables.create
* execs.tables.drop 
* execs.setup
* execs.teardown

Which hooks to run will depend on the client being used. In the case of the
Mnesia (default) client, a schema must first be created and then the tables can be created.

The setup/teardown tasks run both the schema and table creation and destruction tasks respectively.

## Configuration
There are a few possible configuration values, with sensible defaults, for this package:

Key                  | Default Value         | Affect
:--------------------| :---------------------| :--------------------------------
ai_table_name        | ai_table              | Name of the autoincrement table
data_table_name      | data_table            | Name of the data table
db_client            | Execs.DbClient.Mnesia | Client module performs db interactions
purge_data_on_start  | false                 | Clean tables of all data on start


## Examples
These are some basic examples. See documentation and tests for more thorough coverage.
```elixir
# Write a value to a single key, of a single component, of a single entity 
Execs.transaction(fn ->
  Execs.write(id, :foo, :bar, :foobar)
end)

# Write a value to a single key, of multiple component, of a single entity 
Execs.transaction(fn ->
  Execs.write(id, [:foo, :bar], :bar, :foobar)
end)

# Write a value to multiple keys, of multiple component, of multiple entities 
Execs.transaction(fn ->
  Execs.write([id, id2], [:foo, :bar], [:foo, :bar], :foobar)
end)

# Read an entire entity from database 
Execs.transaction(fn ->
  Execs.read(id)
end)

# Read the value of a single key from database 
Execs.transaction(fn ->
  Execs.read(id, :foo, :bar)
end)
```

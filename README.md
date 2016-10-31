# execs
Elixir Entity Component System. Abstracts away the mechanisms used to store, lookup, and retrieve data in an Entity-Component System.

At the moment only supports a mnesia client, with limited ability to configure the system. This state may change as the package sees more use.

Note that this application only provides the mechanisms for working with data and expects the consuming application to provide the "System" part of the equation.

WARNING: This software is new and has been minimally tested.

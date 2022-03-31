# Building

First, build and start the database

```bash
bash db.sh
```

Then, build the Elixir/Phoenix container and set up an alias

```bash
bash phx.sh
alias phx="docker run --rm -it -w /app -v $(pwd)/src:/app -p 4000:4000 --network phx-swampland-network phx $1"
```

This gives a `phx` command that can be used to run commands inside of the Phoenix container. For example, a simple interactive Elixir shell can be started by running `phx iex`

Next, we need to create and set up the database:

```bash
phx mix ecto.create
phx mix ecto.migrate
```

# Project

## Running

Provided that you built the containers and set up the alias above, you can start the server by running `phx mix phx.server`, or `phx iex -S mix phx.server` if you want an interactive shell

# Issues

* .5 credit courses aren't handled
* Handle duplicate courses

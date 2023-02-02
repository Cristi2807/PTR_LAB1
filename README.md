# Ptr.Lab1

This README describes the tasks performed for the first Laboratory Work for **PTR** subject, Week 1.

## How to run this project?

First of all , clone this repo.

## Printing Hello PTR to stdout

In order to print "Hello PTR", open a terminal inside that repo and type following command.

```
iex -S mix
```

This above command will open the elixir interactive shell with the modules from the project pre-loaded.

Execute the `hello` function in the following way.

```
iex(1)> Ptr.Lab1.hello()
Hello PTR
:hello_ptr
```

## Running the unit and the doc tests

Execute the following command.

```
mix test
```

You should expect an output similar to the one below

```
Compiling 1 file (.ex)
Generated ptr_lab1 app
Hello PTR
.
Finished in 0.09 seconds (0.00s async, 0.09s sync)
1 test, 0 failures

Randomized with seed 406387
```

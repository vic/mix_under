# mix under

<a href="https://travis-ci.org/vic/mix_under"><img src="https://travis-ci.org/vic/mix_under.svg"></a>


Execute mix tasks under specific umbrella apps, useful for running ecto migrations or tests.

## Usage

```shell
mix under GLOB [TASK...]
```

## Example

Having an example umbrella app like:

```shell
example/
  apps/
    earth/
    heaven/
    hell/
```

This will run test on a single app

```shell
$ mix under heaven test
Heaven
..

Finished in 0.05 seconds
1 doctest, 1 test, 0 failures

Randomized with seed 132550
```

Or you can use a glob (be sure to quote it to prevent your shell from expanding the glob itself)

```shell
$ mix under 'he*' test
Heaven
..

Finished in 0.05 seconds
1 doctest, 1 test, 0 failures

Randomized with seed 941219

.Hell
.

Finished in 0.05 seconds
1 doctest, 1 test, 0 failures

Randomized with seed 862534
```

## How about `mix cmd --app heaven mix test`?

Well, you can of course use it if you dont mind writing a bit more :),
(you can always create an alias in your umbrella to run those long commands for you).

## Under any directory

When the glob given to `mix under` looks like a path (it contains `/`), the glob
is used directly without prepending `apps/` to it.

```shell
mix under apps/hell test
```

This means, you can execute mix on any directory, not only below your umbrella.

```shell
mix under /other/project test
```

## Under relative task arguments

When the task you are executing expects a path to a file to work with (for example for
executing a script or only one test file), `mix under` will convert given relative paths
to absolute. 

This comes handy for executing mix from inside your IDE which would probably use paths
relative to your project root.

```shell
$ mix under earth test apps/earth/test/angel_test.exs
==> (under apps/earth) mix test /home/vic/h/mix_under/example/apps/earth/test/angel_test.exs
Earth.Angel
.

Finished in 0.04 seconds
1 test, 0 failures

Randomized with seed 700004
```

## Relative paths

When you `mix under` has 


This is something not provided by the more generic `mix cmd`.


## Installation

```elixir
def deps do
  [
    {:mix_under, "~> 0.1.0", only: [:dev, :test]}
  ]
end
```

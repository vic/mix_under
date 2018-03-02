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

## Installation

```elixir
def deps do
  [
    {:mix_under, "~> 0.1.0", only: [:dev, :test]}
  ]
end
```

# Define scale by entering its relative step sizes

Where [`asword()`](https://satbq.github.io/musicMCT/reference/asword.md)
takes you from a scale to a ranked list of its step sizes,
`realize_stepword` does the opposite: given a list of ranked step sizes,
it defines a scale with those steps. It does not attempt to define a
scale that exists in 12-tone equal temperament or another mod k
universe, though the result will have integral values in *some* mod k
setting. If you want that information, set `reconvert` to `FALSE`.

## Usage

``` r
realize_stepword(stepword, edo = 12, reconvert = TRUE)
```

## Arguments

- stepword:

  A numeric vector (intended to be nonnegative integers) of ranked step
  sizes; should be the same length as desired output set.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- reconvert:

  Boolean. Should the result be expressed measured in terms of semitones
  (or a different mod k step if edo is not set to 12)?

## Value

Numeric vector of same length as set, if `reconvert` is `TRUE`. If
`reconvert` is `FALSE`, returns a list with two elements. The first
element (`set`) expresses the defined set as integer values in some edo.
The second element (`edo`) tells you which edo (mod k universe) the set
is defined in.

## Examples

``` r
dim7 <- realize_stepword(c(1, 1, 1, 1))
four_on_the_floor <- realize_stepword(c(1, 1, 1, 1), edo=16)
my_luggage <- realize_stepword(c(1, 2, 3, 4, 5))
my_luggage_in_15edo <- realize_stepword(c(1, 2, 3, 4, 5), reconvert=FALSE)
dim7
#> [1] 0 3 6 9
four_on_the_floor
#> [1]  0  4  8 12
my_luggage
#> [1] 0.0 0.8 2.4 4.8 8.0
my_luggage_in_15edo
#> $set
#> [1]  0  1  3  6 10
#> 
#> $edo
#> [1] 15
#> 

pwf_scale <- realize_stepword(c(3, 2, 1, 3, 2, 3, 1))
asword(pwf_scale)
#> [1] 3 2 1 3 2 3 1
```

# Define a step size for one of Wendy Carlos's scales

For her album *Beauty in the Beast*, Wendy Carlos developed several
non-octave scales whose step sizes are calculated to optimize
approximations of three intervals: the 3:2 fifth, the 5:4 major third,
and the 6:5 minor third. The alpha, beta, gamma, and delta scales differ
in terms of how strongly they privilege each of those just intervals.
The basic step size for each scale is created by calling this function
with the appropriate `name` argument (e.g. "alpha"). You can also choose
your own weights for the three approximated just intervals, in which
case the `name` argument is overridden.

## Usage

``` r
carlos_step(name = "alpha", weights = NULL, edo = 12)
```

## Arguments

- name:

  Which of Carlos's four scales to create: `"alpha"`, `"beta"`,
  `"gamma"`, or `"delta"`. Defaults to `"alpha"`

- weights:

  Numeric vector of length 3 assigning the number of steps that
  correspond to 3:2, 5:4, and 6:5, respectively. Overrides `name` if
  specified.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Single numeric value containing the step size for the desired scale

## Examples

``` r
alpha_scale <- (0:31) * carlos_step()
practically_12tet <- (0:24) * carlos_step(weights=c(7, 4, 3))
```

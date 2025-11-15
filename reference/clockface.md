# Visualize a set in pitch-class space

No-frills way to plot the elements of a set on the circular "clockface"
of pc-set theory pedagogy. (See e.g. Straus 2016, ISBN: 9781324045076.)

## Usage

``` r
clockface(set, edo = 12)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Invisible copy of the input `set`

## Examples

``` r
just_diatonic <- j(dia)
clockface(just_diatonic)


double_tresillo <- c(0, 3, 6, 9, 12, 14)
clockface(double_tresillo, edo=16)

```

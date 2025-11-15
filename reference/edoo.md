# Perfectly even scales (the color white)

Creates a perfectly even scale that divides the octave into n equal
steps. Such scales serve as the origin for the hyperplane arrangements
of Modal Color Theory, whence the name `edoo` for "**e**qual
**d**ivision of the **o**ctave **o**rigin."

## Usage

``` r
edoo(card, edo = 12)
```

## Arguments

- card:

  Number of notes in the scale. Numeric.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Numeric vector of length `card` representing a scale of `card` notes.

## Examples

``` r
edoo(5)
#> [1] 0.0 2.4 4.8 7.2 9.6
edoo(5, edo=15)
#> [1]  0  3  6  9 12
octatonic_scale <- tc(edoo(4), c(0, 1))
print(octatonic_scale)
#> [1]  0  1  3  4  6  7  9 10
```

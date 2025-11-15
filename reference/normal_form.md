# Hook's OPTIC normal forms

Following Hook (2023, 416-18, ISBN: 9780190246013), calculates a normal
form for the input `set` using any combination of OPTIC symmetries.

## Usage

``` r
normal_form(set, optic = "opc", edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- optic:

  String: the OPTIC symmetries to apply. Defaults to "opc".

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric vector with the desired normal form of `set`

## Details

This function is designed for flexibility in the `optic` parameter, not
speed. In situations where you need to calculate a large number of
OPTIC- or OPTC-normal forms, you should use
[`primeform()`](https://satbq.github.io/musicMCT/reference/primeform.md)
or [`tnprime()`](https://satbq.github.io/musicMCT/reference/tnprime.md)
respectively, which are considerably faster.

## See also

[`primeform()`](https://satbq.github.io/musicMCT/reference/primeform.md),
[`tnprime()`](https://satbq.github.io/musicMCT/reference/tnprime.md),
and [`startzero()`](https://satbq.github.io/musicMCT/reference/tn.md)
for faster functions dedicated to specific symmetry combinations

## Examples

``` r
# See Exercise 10.4.8 in Hook (2023, 420):
eroica <- c(-25, -13, -6, -3, 0, 3)
normal_form(eroica, optic="pti")
#> [1]  0  3  6  9 16 28
normal_form(eroica, optic="op")
#> [1]  9 11 11  0  3  6

# See Table 10.4.1 in Hook (2023, 417):
alpha <- c(-5, -11, 14, 9, 14, 14, 2)
num_symmetries <- sample(0:5, 1)
random_symmetries <- sample(c("o", "p", "t", "i", "c"), num_symmetries)
random_symmetries <- paste(random_symmetries, collapse="")
print(random_symmetries)
#> [1] ""
normal_form(alpha, optic=random_symmetries)
#> [1]  -5 -11  14   9  14  14   2
```

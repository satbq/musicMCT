# Set class from Forte's list

Given a cardinality and ordinal position, returns the (Rahn) prime form
of the set class from Allen Forte's list in *The Structure of Atonal
Music* (1973). Draws the information from hard-coded values in the
package's data.

## Usage

``` r
sc(card, num)
```

## Arguments

- card:

  Integer value between 1 and 12 (inclusive) that indicates the number
  of distinct pitch-classes in the set class.

- num:

  Ordinal number of the desired set class in Forte's list

## Value

Numeric vector of length `card` representing a pc-set of `card` notes.

## Examples

``` r
ait1 <- sc(4, 15)
ait2 <- sc(4, 29)

NB_rahn_prime_form <- sc(6, 31)
print(NB_rahn_prime_form)
#> [1] 0 1 4 5 7 9
```

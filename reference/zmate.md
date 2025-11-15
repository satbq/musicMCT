# Twin set in the Z-relation (Z mate)

For the standard 12edo sets of Fortean pitch-class set theory, given one
pitch-class set, finds a set class whose interval-class vector is the
same as the input set but which does not include the input set. Not all
set classes participate in the Z-relation, in which case the function
returns `NA`.

## Usage

``` r
zmate(set)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

## Value

`NA` or numeric vector of same length as `set`

## Details

These values are hard-coded from Forte's list for non-hexachords and
only work for subsets of the standard chromatic scale. `zmate()` doesn't
even give you an option to work in a different `edo`. If it were to do
so, I can't see a better solution than calculating all the set classes
of a given cardinality on the spot, which can be slow for higher `edo`s.

## Examples

``` r
zmate(c(0, 4, 7))
#> [1] NA
zmate(c(0, 1, 4, 6))
#> [1] 0 1 3 7
```

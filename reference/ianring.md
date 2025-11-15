# Look up a scale at Ian Ring's *Exciting Universe of Music Theory*

Ian Ring's website [*The Exciting Universe of Music
Theory*](https://ianring.com/musictheory/) is a comprehensive and useful
compilation of information about pitch-class sets in twelve-tone equal
temperament. It tracks many properties that musicMCT is unlikely to
duplicate, so this function opens the corresponding page for a pc-set in
your browser. This only works for sets in 12-edo which include
pitch-class 0.

## Usage

``` r
ianring(set)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

## Value

Invisibly, the integer which Ring's site uses to index the input `set`.
The main purpose of the function is its side effect of opening a page of
Ring's site in a browser.

## Examples

``` r
c_major <- c(0, 2, 4, 5, 7, 9, 11)
c_major_value <- ianring(c_major)
print(c_major_value)
#> [1] 2741
# And indeed you should find information about the major scale
# at https://ianring.com/musictheory/scales/2741

if (FALSE) { # interactive()
ianring(c(0, 2, 3, 7, 8))
}
```

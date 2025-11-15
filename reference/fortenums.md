# Allen Forte's list of set classes

For compatibility with music theory's traditional pitch-class set
theory, whose landmark text is Allen Forte's 1973 *The Structure of
Atonal Music*, the data set `fortenums` hard-codes the ordinal positions
of 12-equal pitch-class set classes from Allen Forte's list. This allows
us to look up specific set classes from Forte numbers or vice versa.
[`sc()`](https://satbq.github.io/musicMCT/reference/sc.md) does the
former and
[`fortenum()`](https://satbq.github.io/musicMCT/reference/fortenum.md)
does the latter. There's very little need to ever interact with the file
`fortenums` itself: you should be able to get anything you need from
this data through either
[`sc()`](https://satbq.github.io/musicMCT/reference/sc.md) or
[`fortenum()`](https://satbq.github.io/musicMCT/reference/fortenum.md).

Note that
[`primeform()`](https://satbq.github.io/musicMCT/reference/primeform.md)
in `musicMCT` uses Rahn's algorithm rather than Forte's for finding a
canonical representative of each set class. Consequently, the entries of
`fortenums` also use Rahn's prime forms rather than Forte's.

## Usage

``` r
fortenums
```

## Format

A list of length 12. The nth entry of the list corresponds to set
classes of cardinality n. Each list entry is a vector of character
strings; every element of the vector contains a Rahn prime form as a
comma-delimited string. These prime forms are ordered in the same
sequence as Forte's list. Thus, for instance, the set class of the minor
triad is represented by the string `"0, 3, 7"`, which is the 11th
element in `fortenums[[3]]`.

## Source

Forte, Allen. 1973. *The Structure of Atonal Music*. New Haven, CT: Yale
University Press. Appendix 1, pp. 179-181.

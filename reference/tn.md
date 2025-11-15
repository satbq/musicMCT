# Transposition and Inversion

Calculate the classic operations on pitch-class sets \\T_n\\ and \\T_n
I\\. That is, `tn` adds a constant to all elements in a set modulo the
octave, and `tni` essentially multiplies a set by `-1` (modulo the
octave) and then adds a constant (modulo the octave). If `sorted` is
`TRUE` (as is default), the resulting set is listed in ascending order,
but sometimes it can be useful to track transformational voice leadings,
in which case you should set `sorted` to `FALSE`.

`startzero` transposes a set so that its first element is `0`. (Note
that this is different from
[`tnprime()`](https://satbq.github.io/musicMCT/reference/tnprime.md)
because it doesn't attempt to find the most compact form of the set. See
examples for the contrast.)

Sometimes you just want to invert a set and you don't care what the
index is. `charm` is a quick way to do this, giving a name to the
transposition-class of \\T_0 I\\ of the set. (The name `charm` is a
reference to "strange" and "charm" quarks in particle physics: I like
these as names for the "a" and "b" forms of a set class, i.e. the
strange common triad is 3-11a = (0, 3, 7) and the charm common triad is
3-11b = (0, 4, 7). The name of the function `charm` means that if you
input a strange set, you get out a charm set, but NB also vice versa.)

## Usage

``` r
tn(
  set,
  n,
  sorted = TRUE,
  octave_equivalence = TRUE,
  optic = NULL,
  edo = 12,
  rounder = 10
)

tni(
  set,
  n = NULL,
  sorted = TRUE,
  octave_equivalence = TRUE,
  optic = NULL,
  edo = 12,
  rounder = 10
)

startzero(
  set,
  sorted = TRUE,
  octave_equivalence = TRUE,
  optic = NULL,
  edo = 12,
  rounder = 10
)

charm(set, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- n:

  Numeric value (not necessarily an integer) representing the index of
  transposition or inversion. For `tni()` only, defaults to `NULL`, in
  which case `n` is chosen automatically to fix the first and last
  entries of `set` as common tones.

- sorted:

  Do you want the result to be in ascending order? Boolean, defaults to
  `TRUE`.

- octave_equivalence:

  Do you want to normalize the result so that all values are between 0
  and `edo`? Boolean, defaults to `TRUE`.

- optic:

  String: the OPTIC symmetries to apply. Defaults to `NULL`, applying
  symmetries most appropriate to the given function. If specified,
  overrides parameters `sorted` and `octave_equivalence`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric vector of same length as `set`

## Examples

``` r
c_major <- c(0, 4, 7)
tn(c_major, 2)
#> [1] 2 6 9
tn(c_major, -10)
#> [1] 2 6 9
tn(c_major, -10, optic="p") # Equivalent to tn(c_major, -10, octave_equivalence=FALSE)
#> [1] -10  -6  -3
tni(c_major, 4)
#> [1] 0 4 9
tni(c_major, 4, sorted=FALSE)
#> [1] 4 0 9
# If no index is supplied for tni, n is chosen to fix the first and last entries of the set:
tni(c_major)
#> [1] 0 3 7

tn(c(0, 1, 6, 7), 6)
#> [1] 0 1 6 7
tn(c(0, 1, 6, 7), 6, sorted=FALSE)
#> [1] 6 7 0 1

##### Difference between startzero and tnprime
e_maj7 <- c(4, 8, 11, 3)
startzero(e_maj7)
#> [1]  0  4  7 11
tnprime(e_maj7)
#> [1] 0 1 5 8
isTRUE(all.equal(tnprime(e_maj7), charm(e_maj7))) # True because inversionally symmetrical
#> [1] TRUE

##### Derive minimal voice leading from ionian to lydian
ionian <- c(0, 2, 4, 5, 7, 9, 11)
lydian <- rotate(tn(ionian, 7, sorted=FALSE), 3)
lydian - ionian
#> [1] 0 0 0 1 0 0 0

##### Easy to create a 12-tone matrix
row <- c(9, 10, 6, 8, 5, 7, 1, 2, 3, 11, 0, 4)
matrix_from_0 <- sapply(row, tni, set=row, optic="o")
matrix_from_9 <- tn(matrix_from_0, 9, optic="o")
print(matrix_from_0)
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12]
#>  [1,]    0    1    9   11    8   10    4    5    6     2     3     7
#>  [2,]   11    0    8   10    7    9    3    4    5     1     2     6
#>  [3,]    3    4    0    2   11    1    7    8    9     5     6    10
#>  [4,]    1    2   10    0    9   11    5    6    7     3     4     8
#>  [5,]    4    5    1    3    0    2    8    9   10     6     7    11
#>  [6,]    2    3   11    1   10    0    6    7    8     4     5     9
#>  [7,]    8    9    5    7    4    6    0    1    2    10    11     3
#>  [8,]    7    8    4    6    3    5   11    0    1     9    10     2
#>  [9,]    6    7    3    5    2    4   10   11    0     8     9     1
#> [10,]   10   11    7    9    6    8    2    3    4     0     1     5
#> [11,]    9   10    6    8    5    7    1    2    3    11     0     4
#> [12,]    5    6    2    4    1    3    9   10   11     7     8     0
print(matrix_from_9)
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12]
#>  [1,]    9   10    6    8    5    7    1    2    3    11     0     4
#>  [2,]    8    9    5    7    4    6    0    1    2    10    11     3
#>  [3,]    0    1    9   11    8   10    4    5    6     2     3     7
#>  [4,]   10   11    7    9    6    8    2    3    4     0     1     5
#>  [5,]    1    2   10    0    9   11    5    6    7     3     4     8
#>  [6,]   11    0    8   10    7    9    3    4    5     1     2     6
#>  [7,]    5    6    2    4    1    3    9   10   11     7     8     0
#>  [8,]    4    5    1    3    0    2    8    9   10     6     7    11
#>  [9,]    3    4    0    2   11    1    7    8    9     5     6    10
#> [10,]    7    8    4    6    3    5   11    0    1     9    10     2
#> [11,]    6    7    3    5    2    4   10   11    0     8     9     1
#> [12,]    2    3   11    1   10    0    6    7    8     4     5     9
```

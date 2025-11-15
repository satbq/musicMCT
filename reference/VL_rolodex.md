# Minimal voice leadings to all transpositions of some Tn-type mod k

Given a starting set (`source`) and some tn-type as a voice leading goal
(`goal_type`), find the minimal voice leading to every transposition (in
some mod k universe) of the goal. If a goal is not specified, the goal
is assumed to be the tn-type of the `source` set. This lets you see, for
example, the minimal voice leading from C7 to other dominant seventh
chords mod 12. I couldn't think of a suitably serious and clear name for
this information, so the metaphor behind "rolodex" is that these voice
leadings are the contact information that `source` has for all its
acquaintances in `goal_type`.

## Usage

``` r
vl_rolodex(
  source,
  goal_type = NULL,
  reorder = TRUE,
  method = c("taxicab", "euclidean", "chebyshev", "hamming"),
  edo = 12,
  rounder = 10,
  no_ties = FALSE
)
```

## Arguments

- source:

  Numeric vector, the pitch-class set at the start of your voice leading

- goal_type:

  Numeric vector, any pitch-class set representing the tn-type of your
  voice leading goal

- reorder:

  Should the results be listed from smallest to largest voice leading
  size? Defaults to `TRUE`. If `FALSE` results are listed in
  transposition order (i.e. \\T_1\\, \\T_2\\, ..., \\T\_{edo-1}\\,
  \\T_0\\).

- method:

  What distance metric should be used? Defaults to `"taxicab"` but can
  be `"euclidean"`, `"chebyshev"`, or `"hamming"`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- no_ties:

  If multiple VLs are equally small, should only one be returned?
  Defaults to `FALSE`, which is generally what an interactive user
  should want.

## Value

A list of length `edo`, each entry of which represents a voice leading
(or group of tied voice leadings). List entries are named by their
transposition level.

## Examples

``` r
vl_rolodex(c(0, 4, 7))
#> $`0`
#> [1] 0 0 0
#> 
#> $`4`
#> [1] -1  0  1
#> 
#> $`8`
#> [1]  0 -1  1
#> 
#> $`1`
#> [1] 1 1 1
#> 
#> $`3`
#> [1] -2 -1  0
#> 
#> $`5`
#> [1] 0 1 2
#> 
#> $`7`
#> [1] -1 -2  0
#> 
#> $`9`
#> [1] 1 0 2
#> 
#> $`11`
#> [1] -1 -1 -1
#> 
#> $`2`
#>      [,1] [,2] [,3]
#> [1,]    2    2    2
#> [2,]   -3   -2   -1
#> 
#> $`6`
#>      [,1] [,2] [,3]
#> [1,]    1    2    3
#> [2,]   -2   -3   -1
#> 
#> $`10`
#>      [,1] [,2] [,3]
#> [1,]    2    1    3
#> [2,]   -2   -2   -2
#> 

vl_rolodex(c(0, 4, 7), reorder=FALSE)
#> $`1`
#> [1] 1 1 1
#> 
#> $`2`
#>      [,1] [,2] [,3]
#> [1,]    2    2    2
#> [2,]   -3   -2   -1
#> 
#> $`3`
#> [1] -2 -1  0
#> 
#> $`4`
#> [1] -1  0  1
#> 
#> $`5`
#> [1] 0 1 2
#> 
#> $`6`
#>      [,1] [,2] [,3]
#> [1,]    1    2    3
#> [2,]   -2   -3   -1
#> 
#> $`7`
#> [1] -1 -2  0
#> 
#> $`8`
#> [1]  0 -1  1
#> 
#> $`9`
#> [1] 1 0 2
#> 
#> $`10`
#>      [,1] [,2] [,3]
#> [1,]    2    1    3
#> [2,]   -2   -2   -2
#> 
#> $`11`
#> [1] -1 -1 -1
#> 
#> $`0`
#> [1] 0 0 0
#> 

#Multisets sort of work! Best resolutions from dom7 to triads with doubled root:
vl_rolodex(c(0, 4, 7, 10), c(0, 0, 4, 7))
#> $`0`
#> [1] 0 0 0 2
#> 
#> $`3`
#> [1]  3 -1  0  0
#> 
#> $`5`
#> [1]  0  1 -2 -1
#> 
#> $`6`
#> [1]  1  2 -1  0
#> 
#> $`8`
#> [1]  0 -1  1 -2
#> 
#> $`9`
#> [1]  1  0  2 -1
#> 
#> $`11`
#> [1] -1 -1 -1  1
#> 
#> $`1`
#> [1] 1 1 1 3
#> 
#> $`2`
#> [1]  2 -2 -1 -1
#> 
#> $`4`
#>      [,1] [,2] [,3] [,4]
#> [1,]    4    0    1    1
#> [2,]   -1    0   -3   -2
#> 
#> $`7`
#>      [,1] [,2] [,3] [,4]
#> [1,]    2    3    0    1
#> [2,]   -1   -2    0   -3
#> 
#> $`10`
#>      [,1] [,2] [,3] [,4]
#> [1,]    2    1    3    0
#> [2,]   -2   -2   -2    0
#> 
```

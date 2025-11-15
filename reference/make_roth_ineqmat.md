# Define hyperplanes for Rothenberg arrangements

Although the Rothenberg propriety of a single scale can be computed
directly with
[`isproper()`](https://satbq.github.io/musicMCT/reference/isproper.md),
propriety is a scalar feature (like modal "color") which is defined by a
scale's position in the geometry of continuous pc-set space. That is,
propriety, contradictions, and ambiguities are all determined by a
scale's relationship to a hyperplane arrangement, but the arrangements
which define these properties are different from the ones of Modal Color
Theory. `make_roth_ineqmat()` creates the `ineqmats` needed to study
those arrangements, similar to what
[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md)
does for MCT arrangements. `make_rosy_ineqmat()` creates the combination
of Rothenberg and MCT arrangements. (The name puns on the "Roth" of
Rothenberg meaning "red," lending a reddish or rosy tint to the "colors"
of the MCT arrangement.)

Each row of a Rothenberg `ineqmat` represents a hyperplane, just like
the rows produced by
[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md).
The rows are normalized so that their first non-zero entry is either `1`
or `-1`, and their orientations are assigned so that a strictly proper
set will return only `-1`s for its sign vector relative to the
Rothenberg arrangement. A `0` in a Rothenberg sign vector represents an
ambiguity. Note that the Rothenberg arrangements are never "central,"
which means that the hyperplanes do *not* all intersect at the perfectly
even scale. (It is clear that they must not, because perfectly even
scales have no ambiguities.) These arrangements also grow in complexity
much faster than the MCT arrangements do: for tetrachords, MCT
arrangements have 8 hyperplanes while Rothenberg arrangements have 22.
For heptachords, those numbers increase to 42 and 259, respectively.
Thus, this function runs slowly when called on cardinalities of only
modest size (e.g. 12-24). Matrices for cardinalities up through 24 have
been precomputed and are stored in `roth_ineqmats`; `get_roth_ineqmat()`
attempts to access them from that file rather than generating them from
scratch.

## Usage

``` r
make_roth_ineqmat(card)

get_roth_ineqmat(card)

make_rosy_ineqmat(card)
```

## Arguments

- card:

  The cardinality of the scale(s) to be studied

## Value

A matrix with `card+1` columns and k rows, where k is the number of
hyperplanes in the arrangement.

## Examples

``` r
c_major <- c(0, 2, 4, 5, 7, 9, 11)
hepta_roth_ineqmat <- make_roth_ineqmat(7)
isproper(c_major)
#> [1] TRUE
cmaj_roth_sv <- signvector(c_major, ineqmat=hepta_roth_ineqmat)
table(cmaj_roth_sv)
#> cmaj_roth_sv
#>  -1   0 
#> 258   1 
hepta_roth_ineqmat[which(cmaj_roth_sv==0),] 
#> [1]  0.0  0.0  0.0 -1.0  0.0  0.0  1.0 -0.5
# This reveals that c_major has one ambiguity, which results from
# the interval from 4 to 7 being exactly half an octave.
```

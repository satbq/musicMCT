# Hyperplane arrangements for Rothenberg arrangements

The data file `roth_ineqmats` represents the Rothenberg hyperplane
arrangements that
[`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
generates. Just like the file `ineqmats`, for large computations it's
faster simply to call on precalculated data rather than to run
[`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
many thousands of times. Thus the object `roth_ineqmats` saves the
inequality matrices for scales of cardinality 1-24, to be called upon by
[`get_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md).

## Usage

``` r
roth_ineqmats
```

## Format

`roth_ineqmats` A list with 24 entries. The nth entry of the list gives
the inequality matrix for n-note scales. Each inequality matrix itself
is an m by (n+1) matrix, where m is the number of hyperplanes in the
relevant Rothenberg arrangement. (The values m are currently only
empirical: so far, no principled enumeration exists.) The last column of
the matrix contains constants that translate the hyperplane away from
the origin.

## Source

The data in `roth_ineqmats` can be recreated with the command
`sapply(1:24, make_roth_ineqmat)`.

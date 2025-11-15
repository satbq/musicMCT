# Hyperplane arrangements for MCT spaces

The data file `ineqmats` represents the hyperplane arrangements at the
core of Modal Color Theory as matrices containing the hyperplanes'
normal vectors. See Appendix 1.2 of Sherrill (2025) for a discussion of
the format of these matrices. The matrices can be generated on the fly
by
[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md),
but for large computations it's faster simply to call on precalculated
data rather than to run
[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md)
many thousands of times. Thus the object `ineqmats` saves the inequality
matrices for scales of cardinality 1-53, to be called upon by
[`getineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md).

## Usage

``` r
ineqmats
```

## Format

`ineqmats` A list with 53 entries. The nth entry of the list gives the
inequality matrix for n-note scales. Each inequality matrix itself is an
m by (n+1) matrix, where m is an element of [OEIS
A034828](https://oeis.org/A034828) (see Sherrill 2025, 40-42). The last
column of the matrix contains an offset related to whether any of the
generic intervals "wrap around the octave," as e.g. the third from 7 to
2 does in a heptachord. This column is linearly dependent on the
previous n columns, which contain the coefficients of the hyperplane's
normal vectors. That is, the first row of the matrix (dropping its last
entry) is the normal vector for the first hyperplane of the arrangement,
and so on.

## Source

The data in `ineqmats` can be recreated with the command
`sapply(2:53, makeineqmat)` and then appending `integer(0)` as the first
element of the list (for the case of one-note scales which have no
pairwise interval comparisons and therefore need a matrix of size 0).

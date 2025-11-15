# Does a scale lie in the canonical fundamental domain for OPTC symmetries?

Modal Color Theory is capable of describing "scales" (perhaps "melodies"
might be more accurate) which do all sorts of non-scalar things, like
repeating notes, ascending and descending inconsistently, not observing
octave equivalence, and so on. This function tests whether an input has
a 'well-behaved' form in that it starts on `0`, only ascends, doesn't
repeat pitches, and doesn't go above the octave. If you find an
interesting scale structure represented by a set that *doesn't* satisfy
these constraints, you can always desaturate it until it does (i.e. call
something like `saturate(.1, my_scale_with_bad_OPTCs)`).

## Usage

``` r
optc_test(set, edo = 12, rounder = 10, single_answer = TRUE)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- single_answer:

  Should the function return a single value of `TRUE` or `FALSE`?
  Defaults to `TRUE`. If set to `FALSE`, returns a vector of 4 Boolean
  values that indicate whether the scale individually passes O, P, T,
  and C criteria for being in the fundamental domain.

## Value

Either a single Boolean value or a vector of 4 Boolean values, depending
on the `single_answer` argument.

## Examples

``` r
major_triad_normal_form <- c(0, 4, 7)
major_triad_open_spacing <- c(0, 7, 16)
major_triad_voice_crossing <- c(0, 7, 4)
major_triad_on_des <- c(1, 5, 8)
major_triad_doubled_third_omit_5 <- c(0, 4, 4)
example_triads <- cbind(major_triad_normal_form,
         major_triad_open_spacing,
         major_triad_voice_crossing,
         major_triad_on_des,
         major_triad_doubled_third_omit_5)

apply(example_triads, 2, optc_test)
#>          major_triad_normal_form         major_triad_open_spacing 
#>                             TRUE                            FALSE 
#>       major_triad_voice_crossing               major_triad_on_des 
#>                            FALSE                            FALSE 
#> major_triad_doubled_third_omit_5 
#>                            FALSE 
optc_test(major_triad_voice_crossing, single_answer=FALSE)
#>     O     P     T     C 
#>  TRUE FALSE  TRUE  TRUE 
```

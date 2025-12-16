# Package index

## Core MCT Functions

Essential tools for analyzing scale structures and the hyperplane
arrangments of Modal Color Theory.

### Scalar Properties

Gather information about individual scales

- [`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md)
  : Visualize brightness relationships among modes of a scale
- [`colornum()`](https://satbq.github.io/musicMCT/reference/colornum.md)
  : Reference numbers for scale structures
- [`eps()`](https://satbq.github.io/musicMCT/reference/eps.md)
  [`delta()`](https://satbq.github.io/musicMCT/reference/eps.md)
  [`ratio()`](https://satbq.github.io/musicMCT/reference/eps.md) : The
  brightness ratio
- [`howfree()`](https://satbq.github.io/musicMCT/reference/howfree.md) :
  Count a scale's degrees of freedom
- [`ineqsym()`](https://satbq.github.io/musicMCT/reference/ineqsym.md) :
  Symmetries of hyperplane arrangements define equivalent scales
- [`primary_hue()`](https://satbq.github.io/musicMCT/reference/primary_hue.md)
  [`primary_colornum()`](https://satbq.github.io/musicMCT/reference/primary_hue.md)
  [`primary_signvector()`](https://satbq.github.io/musicMCT/reference/primary_hue.md)
  [`primary_color()`](https://satbq.github.io/musicMCT/reference/primary_hue.md)
  : Primary colors
- [`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md)
  : Find a scale mod k that matches a given color
- [`quantize_hue()`](https://satbq.github.io/musicMCT/reference/quantize_hue.md)
  : Find a scale mod k that matches a given hue
- [`same_hue()`](https://satbq.github.io/musicMCT/reference/same_hue.md)
  : Do two scales lie on the same ray?
- [`saturate()`](https://satbq.github.io/musicMCT/reference/saturate.md)
  : Modify evenness without changing hue
- [`scale_palette()`](https://satbq.github.io/musicMCT/reference/scale_palette.md)
  : Orbit of a scale under symmetries of hyperplane arrangement
- [`sim()`](https://satbq.github.io/musicMCT/reference/sim.md) : Scalar
  (and interscalar) interval matrix
- [`simplify_scale()`](https://satbq.github.io/musicMCT/reference/simplify_scale.md)
  [`best_simplification()`](https://satbq.github.io/musicMCT/reference/simplify_scale.md)
  : Best ways to regularize a scale

### Hyperplane Arrangements

Define and manipulate the arrangements which characterize the spaces

- [`get_relevant_rows()`](https://satbq.github.io/musicMCT/reference/get_relevant_rows.md)
  : Which hyperplanes affect a given generic interval?
- [`ineqmats`](https://satbq.github.io/musicMCT/reference/ineqmats.md) :
  Hyperplane arrangements for MCT spaces
- [`make_anaglyph_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_anaglyph_ineqmat.md)
  : Define hyperplanes for cross-type voice leadings
- [`make_black_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md)
  [`make_gray_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md)
  : Define hyperplanes for transposition-sensitive arrangements
- [`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md)
  : Define hyperplanes for infrared arrangements
- [`make_offset_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_offset_ineqmat.md)
  : Translate a hyperplane arrangement to a new center
- [`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
  [`get_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
  [`make_rosy_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
  : Define hyperplanes for Rothenberg arrangements
- [`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md)
  [`make_pastel_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md)
  : Define hyperplanes for white arrangements
- [`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md)
  [`getineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md)
  : Define hyperplanes for the Modal Color Theory arrangements
- [`move_to_hyperplane()`](https://satbq.github.io/musicMCT/reference/move_to_hyperplane.md)
  : Intersection of a line with a hyperplane
- [`point_on_flat()`](https://satbq.github.io/musicMCT/reference/point_on_flat.md)
  : Generate one point on arbitrary combination of hyperplanes
- [`populate_flat()`](https://satbq.github.io/musicMCT/reference/populate_flat.md)
  : Randomly generate scales on a flat
- [`project_onto()`](https://satbq.github.io/musicMCT/reference/project_onto.md)
  [`match_flat()`](https://satbq.github.io/musicMCT/reference/project_onto.md)
  : Closest point on a given flat
- [`roth_ineqmats`](https://satbq.github.io/musicMCT/reference/roth_ineqmats.md)
  : Hyperplane arrangements for Rothenberg arrangements

### Sign vectors

Work directly with the information contained in a sign vector

- [`anazero_fingerprint()`](https://satbq.github.io/musicMCT/reference/anazero_fingerprint.md)
  : Are regularities within or between sets in a pair?
- [`brightness_comparisons()`](https://satbq.github.io/musicMCT/reference/brightness_comparisons.md)
  : Voice-leading brightness relationships for a scale's modes
- [`comparesignvecs()`](https://satbq.github.io/musicMCT/reference/comparesignvecs.md)
  : Do two sign vectors represent adjacent colors?
- [`set_from_signvector()`](https://satbq.github.io/musicMCT/reference/set_from_signvector.md)
  : Create a scale from a sign vector
- [`signvector()`](https://satbq.github.io/musicMCT/reference/signvector.md)
  : Detect a scale's location relative to a hyperplane arrangement
- [`step_signvector()`](https://satbq.github.io/musicMCT/reference/step_signvector.md)
  : Specify a scale's step pattern with a sign vector
- [`svzero_fingerprint()`](https://satbq.github.io/musicMCT/reference/svzero_fingerprint.md)
  : Distinguish different types of interval equalities
- [`whichsvzeroes()`](https://satbq.github.io/musicMCT/reference/whichsvzeroes.md)
  [`countsvzeroes()`](https://satbq.github.io/musicMCT/reference/whichsvzeroes.md)
  : Which interval-comparison equalities does a scale satisfy?

## Other Properties

Tests for miscellaneous scalar properties that aren’t directly tied to
MCT.

- [`evenness()`](https://satbq.github.io/musicMCT/reference/evenness.md)
  : How even is a scale?
- [`isproper()`](https://satbq.github.io/musicMCT/reference/isproper.md)
  [`has_contradiction()`](https://satbq.github.io/musicMCT/reference/isproper.md)
  [`strictly_proper()`](https://satbq.github.io/musicMCT/reference/isproper.md)
  : Rothenberg propriety
- [`optc_test()`](https://satbq.github.io/musicMCT/reference/OPTC_test.md)
  : Does a scale lie in the canonical fundamental domain for OPTC
  symmetries?

## Scales and Intervals

Basic tools for defining musical objects

- [`carlos_step()`](https://satbq.github.io/musicMCT/reference/carlos_step.md)
  : Define a step size for one of Wendy Carlos's scales
- [`convert()`](https://satbq.github.io/musicMCT/reference/convert.md) :
  Convert between octave measurements
- [`coord_to_edo()`](https://satbq.github.io/musicMCT/reference/coord_to_edo.md)
  [`coord_from_edo()`](https://satbq.github.io/musicMCT/reference/coord_to_edo.md)
  : Coordinate systems for scale representation
- [`edoo()`](https://satbq.github.io/musicMCT/reference/edoo.md) :
  Perfectly even scales (the color white)
- [`j()`](https://satbq.github.io/musicMCT/reference/j.md) : Convenient
  just-intonation intervals and scales
- [`maxeven()`](https://satbq.github.io/musicMCT/reference/maxeven.md) :
  Maximally even scales
- [`meantone_fifth()`](https://satbq.github.io/musicMCT/reference/meantone_fifth.md)
  : Define a tempered fifth for various meantone scales
- [`surround_set()`](https://satbq.github.io/musicMCT/reference/surround_set.md)
  : Random scales uniformly distributed on a hypersphere around an input
- [`z()`](https://satbq.github.io/musicMCT/reference/z.md) : Frequency
  ratios to logarithmic pitch intervals (e.g. semitones)

## Set Theory

Concepts from traditional pitch-class set theory

- [`clockface()`](https://satbq.github.io/musicMCT/reference/clockface.md)
  : Visualize a set in pitch-class space
- [`emb()`](https://satbq.github.io/musicMCT/reference/emb.md)
  [`cover()`](https://satbq.github.io/musicMCT/reference/emb.md) : How
  many instances of a subset-type exist within a scale? How many scales
  embed a subset?
- [`fortenum()`](https://satbq.github.io/musicMCT/reference/fortenum.md)
  : Forte number from set class
- [`fortenums`](https://satbq.github.io/musicMCT/reference/fortenums.md)
  : Allen Forte's list of set classes
- [`ifunc()`](https://satbq.github.io/musicMCT/reference/ifunc.md) : All
  intervals from one set to another
- [`isym()`](https://satbq.github.io/musicMCT/reference/isym.md)
  [`isym_index()`](https://satbq.github.io/musicMCT/reference/isym.md)
  [`isym_degree()`](https://satbq.github.io/musicMCT/reference/isym.md)
  : Test for inversional symmetry
- [`ivec()`](https://satbq.github.io/musicMCT/reference/ivec.md) :
  Interval-class vector
- [`normal_form()`](https://satbq.github.io/musicMCT/reference/normal_form.md)
  : Hook's OPTIC normal forms
- [`primeform()`](https://satbq.github.io/musicMCT/reference/primeform.md)
  : Prime form of a set using Rahn's algorithm
- [`sc()`](https://satbq.github.io/musicMCT/reference/sc.md) : Set class
  from Forte's list
- [`sc_comp()`](https://satbq.github.io/musicMCT/reference/sc_comp.md) :
  Set class complement
- [`signed_interval_class()`](https://satbq.github.io/musicMCT/reference/signed_interval_class.md)
  : Ordered pitch-class interval represented as interval class with sign
- [`tc()`](https://satbq.github.io/musicMCT/reference/tc.md) :
  Transpositional combination & pitch multiplication
- [`tn()`](https://satbq.github.io/musicMCT/reference/tn.md)
  [`tni()`](https://satbq.github.io/musicMCT/reference/tn.md)
  [`startzero()`](https://satbq.github.io/musicMCT/reference/tn.md)
  [`charm()`](https://satbq.github.io/musicMCT/reference/tn.md) :
  Transposition and Inversion
- [`tnprime()`](https://satbq.github.io/musicMCT/reference/tnprime.md) :
  Transposition class of a given pc-set
- [`tsym()`](https://satbq.github.io/musicMCT/reference/tsym.md)
  [`tsym_index()`](https://satbq.github.io/musicMCT/reference/tsym.md)
  [`tsym_degree()`](https://satbq.github.io/musicMCT/reference/tsym.md)
  : Test for transpositional symmetry
- [`zmate()`](https://satbq.github.io/musicMCT/reference/zmate.md) :
  Twin set in the Z-relation (Z mate)

## Discrete Fourier Transform

Applications of the DFT to set theory, a la Lewin, Quinn, et al.

- [`dft()`](https://satbq.github.io/musicMCT/reference/dft.md) : The
  musical Discrete Fourier Transform of a pitch-class set
- [`set_to_distribution()`](https://satbq.github.io/musicMCT/reference/set_to_distribution.md)
  [`distribution_to_set()`](https://satbq.github.io/musicMCT/reference/set_to_distribution.md)
  [`s2d()`](https://satbq.github.io/musicMCT/reference/set_to_distribution.md)
  [`d2s()`](https://satbq.github.io/musicMCT/reference/set_to_distribution.md)
  : Convert between pitch-class sets and distributions

## Subsets

Tools for exploring subset-superset relationships in scales

- [`intervalspectrum()`](https://satbq.github.io/musicMCT/reference/intervalspectrum.md)
  [`spectrumcount()`](https://satbq.github.io/musicMCT/reference/intervalspectrum.md)
  : Specific sizes corresponding to each generic interval
- [`subset_multiplicities()`](https://satbq.github.io/musicMCT/reference/subset_multiplicities.md)
  : Count the multiplicities of a subset-type's varieties
- [`subset_varieties()`](https://satbq.github.io/musicMCT/reference/subset_varieties.md)
  : Specific varieties of scalar subsets given a generic shape
- [`subsetspectrum()`](https://satbq.github.io/musicMCT/reference/subsetspectrum.md)
  : Subset varieties for all subsets of a fixed size

## Utilities

Tools that make it convenient to manipulate objects in R

- [`fpunique()`](https://satbq.github.io/musicMCT/reference/fpunique.md)
  : Unique real values up to some tolerance
- [`fpmod()`](https://satbq.github.io/musicMCT/reference/fpmod.md) :
  Modulo division with rounding
- [`rotate()`](https://satbq.github.io/musicMCT/reference/rotate.md) :
  Circular rotation of an ordered tuple

## Voice Leading

Tools for studying how sets are connected by voice leadings

- [`flex_points()`](https://satbq.github.io/musicMCT/reference/flex_points.md)
  : Voice-leading inflection points
- [`minimize_vl()`](https://satbq.github.io/musicMCT/reference/minimize_vl.md)
  : Smallest voice leading between two sets
- [`tndists()`](https://satbq.github.io/musicMCT/reference/tndists.md) :
  Distances between continuous transpositions of a set
- [`vl_dist()`](https://satbq.github.io/musicMCT/reference/vl_dist.md) :
  How far apart are two scales?
- [`vl_generators()`](https://satbq.github.io/musicMCT/reference/vl_generators.md)
  : Which transpositions give elementary voice leadings?
- [`vl_rolodex()`](https://satbq.github.io/musicMCT/reference/VL_rolodex.md)
  : Minimal voice leadings to all transpositions of some Tn-type mod k
- [`vlsig()`](https://satbq.github.io/musicMCT/reference/vlsig.md)
  [`inter_vlsig()`](https://satbq.github.io/musicMCT/reference/vlsig.md)
  : Elementary voice leadings
- [`whichmodebest()`](https://satbq.github.io/musicMCT/reference/whichmodebest.md)
  : Smallest crossing-free voice leading between two pitch-class sets

## Word Theory

Concepts related to representations of scales as algebraic words

- [`asword()`](https://satbq.github.io/musicMCT/reference/asword.md) :
  Algebraic word of a set's step sizes
- [`clampitt_q()`](https://satbq.github.io/musicMCT/reference/clampitt_q.md)
  : Voice leadings between inversions with maximal common tones
- [`isgwf()`](https://satbq.github.io/musicMCT/reference/isgwf.md) : Is
  a scale n-wise well formed?
- [`iswellformed()`](https://satbq.github.io/musicMCT/reference/iswellformed.md)
  : Well-formedness, Myhill's property, and/or moment of symmetry
- [`realize_stepword()`](https://satbq.github.io/musicMCT/reference/realize_stepword.md)
  : Define scale by entering its relative step sizes

## Input/Output

Ways to read & save data for use outside of R

- [`ianring()`](https://satbq.github.io/musicMCT/reference/ianring.md) :

  Look up a scale at Ian Ring's *Exciting Universe of Music Theory*

- [`readSCL()`](https://satbq.github.io/musicMCT/reference/readSCL.md) :
  Import a Scala (.scl) file as a scale

- [`writeSCL()`](https://satbq.github.io/musicMCT/reference/writeSCL.md)
  : Create a Scala tuning file from a given scale

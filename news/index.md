# Changelog

## musicMCT (development version)

- New
  [`point_on_flat()`](https://satbq.github.io/musicMCT/reference/point_on_flat.md)
  generates a concrete point on any given flat of a hyperplane
  arrangement.
- [`ianring()`](https://satbq.github.io/musicMCT/reference/ianring.md)
  gains `is_interactive` parameter which allows explicit control over
  whether the function opens a browser window (mainly to disable the
  browser during tests).
- [`project_onto()`](https://satbq.github.io/musicMCT/reference/project_onto.md)
  now works for hyperplane arrangements that are not central, such as
  those from
  [`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
  and
  [`make_rosy_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md).

## musicMCT 0.3.0

CRAN release: 2025-11-03

- [`brightness_comparisons()`](https://satbq.github.io/musicMCT/reference/brightness_comparisons.md)
  and
  [`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md)
  gain a `goal` parameter that allows voice-leading brightness
  relationships between different sets to be studied.
- New
  [`clampitt_q()`](https://satbq.github.io/musicMCT/reference/clampitt_q.md)
  finds the sets that are “Q-related” to an input (Clampitt 1997, 2007).
- [`colornum()`](https://satbq.github.io/musicMCT/reference/colornum.md)
  now tries to automatically match a signvector list to the specified
  `ineqmat` when the parameter `signvector_list` is `NULL`. (For
  instance, `colornum(set, ineqmat="pastel")` searches the global
  environment for `pastel_signvectors`.)
- New [`fpmod()`](https://satbq.github.io/musicMCT/reference/fpmod.md)
  allows for safer modulo division in contexts with octave equivalence.
- New
  [`inter_vlsig()`](https://satbq.github.io/musicMCT/reference/vlsig.md)
  finds elementary voice leadings between sets of different Tn-types.
- New
  [`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md)
  adds a new family of hyperplane arrangements for studying voice
  leading.
- [`minimize_vl()`](https://satbq.github.io/musicMCT/reference/minimize_vl.md)
  now returns better results when `method="hamming"` by allowing for
  voice crossings ([\#4](https://github.com/satbq/musicMCT/issues/4)).
- [`primary_colornum()`](https://satbq.github.io/musicMCT/reference/primary_hue.md)
  gains a `signvector_list` parameter to pass to
  [`colornum()`](https://satbq.github.io/musicMCT/reference/colornum.md),
  allowing it to work properly for hyperplane arrangements other than
  the “modal color theory” arrangement.
- Parameter `n` for
  [`tni()`](https://satbq.github.io/musicMCT/reference/tn.md) gains a
  default value of `NULL`, in which case the index `n` is chosen to
  create the contextual inversion which keeps the first and last entries
  of `set` fixed.
- [`vl_generators()`](https://satbq.github.io/musicMCT/reference/vl_generators.md)
  now gives correct results for sets which fail
  [`optc_test()`](https://satbq.github.io/musicMCT/reference/OPTC_test.md).
- [`vlsig()`](https://satbq.github.io/musicMCT/reference/vlsig.md)
  parameter `index` now defaults to `NULL`, returning a matrix of all
  elementary voice-leadings.

### More flexible handling of OPTIC symmetries

- New
  [`normal_form()`](https://satbq.github.io/musicMCT/reference/normal_form.md)
  calculates the normal form of a set under any combination of OPTIC
  symmetries, following the algorithm described by Hook (2023, 416-8).
- Set theory functions including
  [`tn()`](https://satbq.github.io/musicMCT/reference/tn.md),
  [`tni()`](https://satbq.github.io/musicMCT/reference/tn.md),
  [`startzero()`](https://satbq.github.io/musicMCT/reference/tn.md), and
  so on gain an `optic` parameter, which allows the user to specify the
  OPTIC symmetries to consider.

### Anaglyph Arrangements

- New
  [`make_anaglyph_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_anaglyph_ineqmat.md)
  allows construction of a new family of hyperplane arrangements
  (anaglyph arrangements) which study voice leadings between sets of
  different set classes.
- New
  [`anazero_fingerprint()`](https://satbq.github.io/musicMCT/reference/anazero_fingerprint.md)
  provides granular information about the types of hyperplanes that a
  pair of sets lie on in the anaglyph arrangement.
- New behavior for
  [`howfree()`](https://satbq.github.io/musicMCT/reference/howfree.md)
  and
  [`colornum()`](https://satbq.github.io/musicMCT/reference/colornum.md)
  because anaglyph arrangements require special handling.

## musicMCT 0.2.0

CRAN release: 2025-07-21

### New ineqmat features

- New
  [`make_black_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md)
  and
  [`make_gray_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md)
  allow new transposition-sensitive hyperplane arrangements to be
  studied; ineqmat parameter for other functions (e.g. 
  [`signvector()`](https://satbq.github.io/musicMCT/reference/signvector.md)
  now accepts “black” and “gray” as options.
- New
  [`make_offset_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_offset_ineqmat.md)
  creates version of standard ineqmats (MCT, white, black, etc.) which
  have been translated to be centered on an arbitrary set.
- Creation functions for ineqmats
  ([`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md),
  [`make_black_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md),
  [`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md),
  [`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md))
  now return a consistent value (`integer(0)`) rather than various
  errors when `card` is small.
- New data set `roth_ineqmats.rda` with precomputed results from
  [`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md);
  accessed with new
  [`get_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md).
- New data sets for pastel and white arrangements (for cardinalities
  \<= 6) uploaded to [modalcolortheory
  repository](https://github.com/satbq/modalcolortheory) and linked in
  the documentation for
  [`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md).

### New behaviors for quantization functions

- Affected functions are
  [`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md),
  [`quantize_hue()`](https://satbq.github.io/musicMCT/reference/quantize_hue.md),
  and
  [`set_from_signvector()`](https://satbq.github.io/musicMCT/reference/set_from_signvector.md).
- Upon failure, quantization functions now return a result whose format
  matches expected success format depending on value of `reconvert`
  parameter. That is, if `reconvert=TRUE`, failure to quantize results
  in a `NA` vector (as before), but if `reconvert=FALSE`, failure to
  quantize results in a list with entries `set` and `edo`, both of which
  are `NA`.
- Quantization functions gain a `target_edo` parameter, which allows
  user to search for desired scales in a specific edo rather than all
  possible edos.

### New Functions

- New
  [`clockface()`](https://satbq.github.io/musicMCT/reference/clockface.md)
  offers a simple plotting mechanism to visualize sets on a pitch-class
  clockface (with numbers corresponding to any equal temperament).
- New
  [`ianring()`](https://satbq.github.io/musicMCT/reference/ianring.md)
  creates a convenient way to open a browser window to information about
  the input set on Ian Ring’s website [The Exciting Universe of Music
  Theory](https://ianring.com/musictheory/).
- New functions for basic applications of the DFT to set theory are
  added. These include
  [`set_to_distribution()`](https://satbq.github.io/musicMCT/reference/set_to_distribution.md),
  [`distribution_to_set()`](https://satbq.github.io/musicMCT/reference/set_to_distribution.md),
  and [`dft()`](https://satbq.github.io/musicMCT/reference/dft.md).

### Updates to Existing Functions

- [`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md)
  now returns an invisible copy of the igraph graph object underlying
  the plotted brightness graph, instead of an invisible `NULL`.
- [`sim()`](https://satbq.github.io/musicMCT/reference/sim.md) gains a
  `goal` parameter, which allows it to calculate the interscalar
  interval matrix for two sets.
- [`vl_generators()`](https://satbq.github.io/musicMCT/reference/vl_generators.md)
  now throws a warning instead of an error when `set` is perfectly even,
  returning a 2-by-0 matrix.

## musicMCT 0.1.2

CRAN release: 2025-06-05

- Updated writeSCL() to require user to enter a path.
- Updated vignette “Visualizing Higher Dimensions” to reset par()
  changes.

## musicMCT 0.1.1

- Removed extraneous license file.

## musicMCT 0.1.0

- Initial CRAN submission.

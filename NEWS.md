# musicMCT (development version)

* `vl_generators()` now throws a warning instead of an error when `set` is 
  perfectly even, returning a 2-by-0 matrix.
* `brightnessgraph()` now returns an invisible copy of the igraph graph object
  underlying the plotted brightness graph, instead of an invisible `NULL`.
* New `clockface()` offers a simple plotting mechanism to visualize sets on
  a pitch-class clockface (with numbers corresponding to any equal temperament).
* New `ianring()` creates a convenient way to open a browser window to information
  about the input set on Ian Ring's website 
  [The Exciting Universe of Music Theory](https://ianring.com/musictheory).
* New functions for basic applications of the DFT to set theory are added. These 
  include `set_to_distribution()`, `distribution_to_set()`, and `dft()`.
* New `make_black_ineqmat()` and `make_gray_ineqmat()` allow new transposition-sensitive
  hyperplane arrangements to be studied; ineqmat parameter for other functions (e.g. 
  `signvector()` now accepts "black" and "gray" as options.
* New data set `roth_ineqmats.rda` with precomputed results from `make_roth_ineqmat()`;
  accessed with new `get_roth_ineqmat()`.
* New `make_offset_ineqmat()` creates version of standard ineqmats (MCT, white, black, etc.)
  which have been translated to be centered on an arbitrary set.
* New data sets for pastel and white arrangements (for cardinalities <= 6) uploaded to
  [modalcolortheory repository](https://github.com/satbq/modalcolortheory) and linked
  in the documentation for `make_white_ineqmat()`.
* `sim()` gains a `goal` parameter, which allows it to calculate the interscalar
  interval matrix for two sets.

## New behaviors for quantization functions 
* Affected functions are `quantize_color()`, `quantize_hue()`, 
  and `set_from_signvector()`.
* Upon failure, quantization functions now return a result whose format matches
  expected success format depending on value of `reconvert` parameter. That is,
  if `reconvert=TRUE`, failure to quantize results in a `NA` vector (as before), but
  if `reconvert=FALSE`, failure to quantize results in a list with entries `set` and
  `edo`, both of which are `NA`.
* Quantization functions gain a `target_edo` parameter, which allows user to search
  for desired scales in a specific edo rather than all possible edos.

# musicMCT 0.1.2

* Updated writeSCL() to require user to enter a path.
* Updated vignette "Visualizing Higher Dimensions" to reset par() changes.

# musicMCT 0.1.1

* Removed extraneous license file.

# musicMCT 0.1.0

* Initial CRAN submission.

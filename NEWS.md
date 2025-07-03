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
  include `set_to_distribution()`.

# musicMCT 0.1.2

* Updated writeSCL() to require user to enter a path.
* Updated vignette "Visualizing Higher Dimensions" to reset par() changes.

# musicMCT 0.1.1

* Removed extraneous license file.

# musicMCT 0.1.0

* Initial CRAN submission.

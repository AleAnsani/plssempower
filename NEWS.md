# plssempower 1.3.0

## New features
* `pls_sem_power()` and `pls_sem_power_graph()` now accept `tail` as an
  explicit alias for `tails`, replacing reliance on partial argument matching.
  Supplying both with conflicting values is an error.

## Input validation
* `N` must be a single positive integer (sensitivity analysis) and `MDES` a
  single positive number (a priori analysis). Invalid values now stop with an
  informative message instead of returning `NaN` or `Inf`.

## Testing
* Added a `testthat` suite covering the one-tailed constants and sample sizes
  of Kock and Hadaya (2018), the two-tailed constants, sensitivity results,
  custom `power`, small-sample warnings, argument validation and the graphs.

## Documentation
* Fixed a malformed roxygen tag (`#' #' @details`) that merged the Details
  section into the `power` argument description.
* README examples now use the canonical `tails` argument.

# plssempower 1.2.0

* Statistical power is now configurable through the `power` argument
  (default 0.80).
* Added the publication-ready `theme = "pr"` for `pls_sem_power_graph()` and
  improved graphical outputs.

# plssempower 1.1.0

* Added two-tailed power and sensitivity analysis via the `tails` argument.

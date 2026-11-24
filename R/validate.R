#' Validate the sample size argument
#'
#' @param N Sample size supplied by the user.
#' @noRd
check_N <- function(N) {
  if (length(N) != 1 || !is.numeric(N) || !is.finite(N) ||
      N <= 0 || abs(N - round(N)) > sqrt(.Machine$double.eps)) {
    stop("N must be a single positive integer")
  }
}

#' Validate the minimum detectable effect size argument
#'
#' @param MDES Minimum detectable effect size supplied by the user.
#' @noRd
check_MDES <- function(MDES) {
  if (length(MDES) != 1 || !is.numeric(MDES) || !is.finite(MDES) || MDES <= 0) {
    stop("MDES must be a single positive number")
  }
}

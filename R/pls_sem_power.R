#' Power or Sensitivity Calculation for PLS-SEM
#'
#' @param method Either "a priori" or "sensitivity"
#' @param N Sample size (required for sensitivity)
#' @param MDES Minimum detectable effect size (required for a priori)
#' @param alpha Significance level: one of 0.01, 0.05, or 0.10
#' @param tails Number of tails: 1 (default) or 2
#' @param power Desired statistical power (default = 0.8)
#' Must be between 0 and 1.
#' #' @details
#' By default, the function performs a one-tailed calculation, following
#' the formulation proposed by Kock and Hadaya (2018). Setting `tails = 2`
#' performs a two-tailed calculation, using the corresponding critical value
#' for the specified significance level.
#' @return Printed result
#' @importFrom stats qnorm
#' @export
#'
pls_sem_power <- function(method = c("sensitivity", "a priori"),
                          N = NULL,
                          MDES = NULL,
                          alpha = 0.05,
                          tails = 1,
                          power = 0.80) {

  method <- match.arg(method)

  # Validate alpha
  alpha <- as.character(alpha)

  if (!alpha %in% c("0.01", "0.05", "0.1")) {
    stop("alpha must be one of: 0.01, 0.05, or 0.10")
  }

  # Validate tails
  if (!tails %in% c(1, 2)) {
    stop("tails must be either 1 or 2")
  }

  # Validate power
  if (length(power) != 1 || !is.numeric(power) ||
      !is.finite(power) || power <= 0 || power >= 1) {
    stop("power must be a single numeric value between 0 and 1")
  }

  # Calculate the critical value
  z_alpha <- if (tails == 1) {
    qnorm(1 - as.numeric(alpha))
  } else {
    qnorm(1 - as.numeric(alpha) / 2)
  }

  z_power <- qnorm(power)

  selected_constant <- z_alpha + z_power

  tail_label <- if (tails == 1) "one-tailed" else "two-tailed"

  if (method == "a priori") {
    if (is.null(MDES)) stop("You must provide MDES for power analysis")
    required_N <- (selected_constant / MDES)^2

    if (ceiling(required_N) <= 10) {
      warning(
        "The inverse square root method is not recommended for sample sizes of 10 or fewer (see Kock & Hadaya, 2018). Consider using the gamma-exponential method instead.",
        call. = FALSE
      )
    }

    cat("To detect an effect of", MDES,
        "with", power * 100, "% power at alpha =", alpha,
        "using a", tail_label, "test, you need at least",
        ceiling(required_N), "observations.\n")
  }

  if (method == "sensitivity") {
    if (is.null(N)) stop("You must provide N for sensitivity analysis")
    detectable_mdes <- selected_constant / sqrt(N)

    if (N <= 10) {
      warning(
        "The inverse square root method is not recommended for sample sizes of 10 or fewer (see Kock & Hadaya, 2018). Consider using the gamma-exponential method instead.",
        call. = FALSE
      )
    }

    cat("With N =", N,
        "and alpha =", alpha,
        "using a", tail_label, "test, you can detect effects as small as",
        ceiling(detectable_mdes * 1000) / 1000,
        "with", power * 100, "% power.\n")
  }
}

#devtools::load_all()

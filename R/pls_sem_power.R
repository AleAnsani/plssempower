#' Power or Sensitivity Calculation for PLS-SEM
#'
#' @param method Either "a priori" or "sensitivity"
#' @param N Sample size (required for sensitivity)
#' @param MDES Minimum detectable effect size (required for a priori)
#' @param alpha Significance level: one of 0.01, 0.05, or 0.10
#' @param tails Number of tails: 1 (default) or 2
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
                          tails = 1) {

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

  # Calculate the critical value
  z_alpha <- if (tails == 1) {
    qnorm(1 - as.numeric(alpha))
  } else {
    qnorm(1 - as.numeric(alpha) / 2)
  }

  z_power <- qnorm(0.80)

  selected_constant <- z_alpha + z_power

  tail_label <- if (tails == 1) "one-tailed" else "two-tailed"

  if (method == "a priori") {
    if (is.null(MDES)) stop("You must provide MDES for power analysis")
    required_N <- (selected_constant / MDES)^2
    cat("To detect an effect of", MDES,
        "with 80% power at alpha =", alpha,
        "using a", tail_label, "test, you need at least",
        ceiling(required_N), "observations.\n")
  }

  if (method == "sensitivity") {
    if (is.null(N)) stop("You must provide N for sensitivity analysis")
    detectable_mdes <- selected_constant / sqrt(N)
    cat("With N =", N,
        "and alpha =", alpha,
        "using a", tail_label, "test, you can detect effects as small as",
        round(detectable_mdes, 2),
        "with 80% power.\n")
  }
}

#devtools::load_all()

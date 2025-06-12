#' Power or Sensitivity Calculation for PLS-SEM
#'
#' @param method Either "a priori" or "sensitivity"
#' @param N Sample size (required for sensitivity)
#' @param MDES Minimum detectable effect size (required for a priori)
#' @param alpha Significance level: one of 0.01, 0.05, or 0.10
#' @return Printed result
#' @export
pls_sem_power <- function(method = c("sensitivity", "a priori"),
                          N = NULL,
                          MDES = NULL,
                          alpha = 0.05) {

  method <- match.arg(method)

  # Validate alpha and map to constants
  alpha <- as.character(alpha)
  p_values <- c("0.01" = 3.168, "0.05" = 2.486, "0.10" = 2.123)

  if (!alpha %in% names(p_values)) {
    stop("alpha must be one of: 0.01, 0.05, or 0.10")
  }

  selected_constant <- p_values[alpha]

  if (method == "a priori") {
    if (is.null(MDES)) stop("You must provide MDES for power analysis")
    required_N <- (selected_constant / MDES)^2
    cat("To detect an effect of", MDES,
        "with 80% power at alpha =", alpha,
        "you need at least", round(required_N, 0), "observations.\n")
  }

  if (method == "sensitivity") {
    if (is.null(N)) stop("You must provide N for sensitivity analysis")
    detectable_mdes <- selected_constant / sqrt(N)
    cat("With N =", N,
        "and alpha =", alpha,
        "you can detect effects as small as", round(detectable_mdes, 2),
        "with 80% power\n")
  }
}

#devtools::load_all()

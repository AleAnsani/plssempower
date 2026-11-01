utils::globalVariables("SampleSize")

#' Plot graph for PLS-SEM power analysis or sensitivity
#'
#' @param method "a priori" (compute sample size) or "sensitivity" (compute MDES)
#' @param MDES Minimum Detectable Effect Size (required if method = "a priori")
#' @param N Sample size (required if method = "sensitivity")
#' @param alpha Significance level. Must be one of 0.01, 0.05, 0.10
#' @param tails Number of tails: 1 (default) or 2
#' @param power Desired statistical power (default = 0.80).
#' Must be a numeric value strictly between 0 and 1.
#' @param theme Plot theme: "abyss" (default), "min" or "pr" (publication-ready)
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_vline geom_hline
#' @importFrom ggplot2 scale_y_continuous scale_x_continuous coord_cartesian labs theme
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 annotate
#' @importFrom see theme_abyss
#' @importFrom stats qnorm
#' @importFrom rlang .data

#' @return A ggplot object
#' @export

pls_sem_power_graph <- function(method = "a priori", MDES = NULL, N = NULL,
                                alpha = 0.05, tails = 1, power = 0.80,
                                theme = "abyss") {

  # Validate alpha
  alpha_str <- as.character(alpha)

  if (!(alpha_str %in% c("0.01", "0.05", "0.1"))) {
    stop("alpha must be one of: 0.01, 0.05, 0.10")
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
    qnorm(1 - as.numeric(alpha_str))
  } else {
    qnorm(1 - as.numeric(alpha_str) / 2)
  }

  z_power <- qnorm(power)

  selected_constant <- z_alpha + z_power

  alpha_label <- switch(
    alpha_str,
    "0.01" = ".01",
    "0.05" = ".05",
    "0.1" = ".10"
  )

  tail_label <- if (tails == 1) {
    "One-tailed test"
  } else {
    "Two-tailed test"
  }


  subtitle_colour <- if (theme %in% c("min", "pr")) {
    "#333333"
  } else if (method == "a priori") {
    "#f0e442"
  } else {
    "#d55e00"
  }

  chosen_theme <- if (theme %in% c("min", "pr")) {
    ggplot2::theme_bw(base_size = 12, base_family = "Times") +
      ggplot2::theme(
        plot.title = ggplot2::element_text(
          face = "bold",
          size = 12,
          hjust = 0.5
        ),
        axis.title = ggplot2::element_text(size = 11),
        axis.text = ggplot2::element_text(size = 10, colour = "#222222"),
        axis.line = ggplot2::element_line(colour = "#333333"),
        axis.ticks = ggplot2::element_line(colour = "#333333"),
        panel.grid.major.y = ggplot2::element_line(
          colour = "#E5E5E5",
          linewidth = 0.3
        ),
        panel.grid.minor = ggplot2::element_blank(),
        legend.position = "none"
      )
  } else {
    see::theme_abyss()
  }

  main_colour <- if (theme %in% c("min", "pr")) "#333333" else "#f0e442"
  sensitivity_colour <- if (theme %in% c("min", "pr")) "#333333" else "#d55e00"


  if (method == "a priori") {
    if (is.null(MDES)) stop("Please provide a value for MDES.")
    mdes_values <- seq(0.05, 1, by = 0.025)
    sample_size_values <- (selected_constant / mdes_values)^2
    target_y <- (selected_constant / MDES)^2

    if (ceiling(target_y) <= 10) {
      warning(
        "The inverse square root method is not recommended for sample sizes of 10 or fewer (see Kock & Hadaya, 2018). Consider using the gamma-exponential method instead.",
        call. = FALSE
      )
    }

    ylim_max <- max(50, ceiling(target_y / 50) * 50)
    break_step <- ceiling(ylim_max / 10 / 10) * 10
    data <- data.frame(MDES = mdes_values, SampleSize = sample_size_values)

    ggplot(data, aes(x = MDES, y = .data$SampleSize)) +
      geom_line(color = main_colour, linewidth = 1) +
      geom_point(color = main_colour, size = 2) +
      geom_vline(xintercept = MDES, color = main_colour, linetype = "dotted", linewidth = 1.25) +
      geom_hline(yintercept = target_y, color = main_colour, linetype = "dotted", linewidth = 1.25) +
      scale_x_continuous(breaks = seq(0.1, 1, by = 0.05)) +
      scale_y_continuous(breaks = seq(0, ylim_max, by = break_step)) +
      coord_cartesian(ylim = c(0, ylim_max)) +
      labs(
        title = "Graph of MDES and Sample Size (A priori)",
        subtitle = paste0(
          "Required sample size = ", ceiling(target_y),
          " | Power = ", power * 100, "%",
          " | \u03B1 = ", alpha_label,
          " | ", tail_label
        ),
        x = "MDES",
        y = "Sample Size"
      ) +
      chosen_theme +
      theme(
        text = element_text(size = 13),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(
          colour = subtitle_colour,
          hjust = 0.5
        )
      )

  } else if (method == "sensitivity") {
    if (is.null(N)) stop("Please provide a value for N.")

    if (N <= 10) {
      warning(
        "The inverse square root method is not recommended for sample sizes of 10 or fewer (see Kock & Hadaya, 2018). Consider using the gamma-exponential method instead.",
        call. = FALSE
      )
    }

    sample_size_values <- seq(0, 300, by = 10)
    mdes_values <- selected_constant / sqrt(sample_size_values)
    mdes_values[sample_size_values == 0] <- NA
    mdes_max <- ceiling((selected_constant / sqrt(N)) / 0.1) * 0.1
    break_step_y <- max(round(mdes_max / 10, 2), 0.01)
    data <- data.frame(SampleSize = sample_size_values, MDES = mdes_values)

    ggplot(data, aes(x = SampleSize, y = MDES)) +
      geom_line(color = sensitivity_colour, linewidth = 1) +
      geom_point(color = sensitivity_colour, size = 2) +
      geom_vline(xintercept = N, color = sensitivity_colour, linetype = "dotted", linewidth = 1.25) +
      geom_hline(yintercept = (selected_constant / sqrt(N)), color = sensitivity_colour, linetype = "dotted", linewidth = 1.25) +
      scale_x_continuous(breaks = seq(0, 300, by = 25)) +
      scale_y_continuous(breaks = seq(0, mdes_max, by = break_step_y)) +
      coord_cartesian(xlim = c(0, 300), ylim = c(0, mdes_max)) +
      labs(
        title = "Graph of Sample Size and MDES (Sensitivity)",
        subtitle = paste0(
          "MDES = ", ceiling((selected_constant / sqrt(N)) * 1000) / 1000,
          " | Power = ", power * 100, "%",
          " | \u03B1 = ", alpha_label,
          " | ", tail_label
        ),
        x = "Sample Size",
        y = "MDES"
      )+
      chosen_theme +
      theme(
        text = element_text(size = 13),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(
          colour = subtitle_colour,
          hjust = 0.5
        )
      )

  } else {
    stop("Invalid method. Choose either 'a priori' or 'sensitivity'.")
  }
}




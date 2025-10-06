#' Plot graph for PLS-SEM power analysis or sensitivity
#'
#' @param method "a priori" (compute sample size) or "sensitivity" (compute MDES)
#' @param MDES Minimum Detectable Effect Size (required if method = "a priori")
#' @param N Sample size (required if method = "sensitivity")
#' @param alpha Significance level. Must be one of 0.01, 0.05, 0.10
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_vline geom_hline
#' @importFrom ggplot2 scale_y_continuous scale_x_continuous coord_cartesian labs theme
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 annotate
#' @importFrom see theme_abyss
#'
#' @return A ggplot object
#' @export
pls_sem_power_graph <- function(method = "a priori", MDES = NULL, N = NULL, alpha = 0.05, theme = "abyss") {
  # Validate alpha
  alpha_map <- c("0.01" = 3.168, "0.05" = 2.486, "0.1" = 2.123)
  alpha_str <- as.character(alpha)
  if (!(alpha_str %in% names(alpha_map))) {
    stop("alpha must be one of: 0.01, 0.05, 0.10")
  }
  selected_constant <- alpha_map[[alpha_str]]
  chosen_theme <- if (theme == "min") ggplot2::theme_minimal() else see::theme_abyss()

  if (method == "a priori") {
    if (is.null(MDES)) stop("Please provide a value for MDES.")
    mdes_values <- seq(0.05, 0.8, by = 0.025)
    sample_size_values <- (selected_constant / mdes_values)^2
    target_y <- (selected_constant / MDES)^2
    ylim_max <- ceiling(target_y / 50) * 50
    break_step <- ceiling(ylim_max / 10 / 10) * 10
    data <- data.frame(MDES = mdes_values, SampleSize = sample_size_values)

    ggplot(data, aes(x = MDES, y = SampleSize)) +
      geom_line(color = "orange", size = 1) +
      geom_point(color = "orange", size = 2) +
      geom_vline(xintercept = MDES, color = "orange", linetype = "dotted", size = 1.25) +
      geom_hline(yintercept = target_y, color = "orange", linetype = "dotted", size = 1.25) +
      scale_x_continuous(breaks = seq(0.1, 0.8, by = 0.05)) +
      scale_y_continuous(breaks = seq(0, ylim_max, by = break_step)) +
      coord_cartesian(ylim = c(0, ylim_max)) +
      labs(title = "Graph of MDES and Sample Size (A priori)",
           x = "MDES", y = "Sample Size") +
      chosen_theme +
      theme(text = element_text(size = 13), plot.title = element_text(hjust = 0.5))+
      annotate("text", x = 0.15, y = ylim_max * 0.9,
                 label = paste0("Sample size ≈ ", round(target_y, 0)),
                 color = "orange", size = 5, hjust = 0)

  } else if (method == "sensitivity") {
    if (is.null(N)) stop("Please provide a value for N.")
    sample_size_values <- seq(0, 300, by = 10)
    mdes_values <- selected_constant / sqrt(sample_size_values)
    mdes_values[sample_size_values == 0] <- NA
    mdes_max <- ceiling((selected_constant / sqrt(N)) / 0.1) * 0.1
    break_step_y <- round(mdes_max / 10, 2)
    data <- data.frame(SampleSize = sample_size_values, MDES = mdes_values)

    ggplot(data, aes(x = SampleSize, y = MDES)) +
      geom_line(color = "red") +
      geom_point(color = "red", size = 2) +
      geom_vline(xintercept = N, color = "red", linetype = "dotted", size = 1.25) +
      geom_hline(yintercept = (selected_constant / sqrt(N)), color = "red", linetype = "dotted", size = 1.25) +
      scale_x_continuous(breaks = seq(0, 300, by = 25)) +
      scale_y_continuous(breaks = seq(0, mdes_max, by = break_step_y)) +
      coord_cartesian(xlim = c(0, 300), ylim = c(0, mdes_max)) +
      labs(title = "Graph of Sample Size and MDES (Sensitivity)",
           x = "Sample Size", y = "MDES") +
      chosen_theme +
      theme(text = element_text(size = 13), plot.title = element_text(hjust = 0.5))+
      annotate("text", x = 10, y = mdes_max * 0.9,
               label = paste0("MDES ≈ ", round(selected_constant / sqrt(N), 2)),
               color = "red", size = 5, hjust = 0)

  } else {
    stop("Invalid method. Choose either 'a priori' or 'sensitivity'.")
  }
}




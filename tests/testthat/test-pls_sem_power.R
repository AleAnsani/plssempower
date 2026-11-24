test_that("one-tailed critical constants match Kock and Hadaya (2018)", {
  calc_const <- function(alpha, tails = 1, power = 0.80) {
    z_alpha <- if (tails == 1) stats::qnorm(1 - alpha) else stats::qnorm(1 - alpha / 2)
    z_power <- stats::qnorm(power)
    z_alpha + z_power
  }

  # Constants from Table 1 in Kock and Hadaya (2018) for 80% power:
  # alpha = 0.01: 3.168
  # alpha = 0.05: 2.486
  # alpha = 0.10: 2.123
  expect_equal(round(calc_const(0.01, tails = 1, power = 0.80), 3), 3.168)
  expect_equal(round(calc_const(0.05, tails = 1, power = 0.80), 3), 2.486)
  expect_equal(round(calc_const(0.10, tails = 1, power = 0.80), 3), 2.123)

  # Check required N = 25 for MDES = 0.5 at alpha = 0.05, power = 0.80
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.05, tails = 1, power = 0.80),
    "you need at least 25 observations"
  )

  # Check required N = 41 for MDES = 0.5 at alpha = 0.01, power = 0.80
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.01, tails = 1, power = 0.80),
    "you need at least 41 observations"
  )

  # Check required N = 19 for MDES = 0.5 at alpha = 0.10, power = 0.80
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.10, tails = 1, power = 0.80),
    "you need at least 19 observations"
  )
})

test_that("two-tailed critical constants match theoretical footnote values", {
  calc_const <- function(alpha, tails = 2, power = 0.80) {
    z_alpha <- stats::qnorm(1 - alpha / 2)
    z_power <- stats::qnorm(power)
    z_alpha + z_power
  }

  # Constants from the manuscript footnote:
  # alpha = 0.01: z(0.995) + z(0.80) = 2.5758 + 0.8416 = 3.4175 (reported as 3.418)
  # alpha = 0.05: z(0.975) + z(0.80) = 1.9600 + 0.8416 = 2.8016 (reported as 2.801 / 2.802)
  # alpha = 0.10: z(0.950) + z(0.80) = 1.6449 + 0.8416 = 2.4865 (reported as 2.486)
  expect_equal(calc_const(0.01, tails = 2, power = 0.80), 3.418, tolerance = 1e-3)
  expect_equal(calc_const(0.05, tails = 2, power = 0.80), 2.801, tolerance = 1e-3)
  expect_equal(calc_const(0.10, tails = 2, power = 0.80), 2.486, tolerance = 1e-3)

  # Two-tailed alpha = 0.10 must equal one-tailed alpha = 0.05
  expect_equal(
    calc_const(0.10, tails = 2, power = 0.80),
    stats::qnorm(1 - 0.05) + stats::qnorm(0.80)
  )

  # Check required N = 25 for MDES = 0.5 at alpha = 0.10, two-tailed, power = 0.80
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.10, tails = 2, power = 0.80),
    "you need at least 25 observations"
  )

  # Check required N = 32 for MDES = 0.5 at alpha = 0.05, two-tailed, power = 0.80
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.05, tails = 2, power = 0.80),
    "you need at least 32 observations"
  )

  # Check required N = 47 for MDES = 0.5 at alpha = 0.01, two-tailed, power = 0.80
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.01, tails = 2, power = 0.80),
    "you need at least 47 observations"
  )
})

test_that("sensitivity analysis computes correct detectable effect size", {
  # N = 25, alpha = 0.05, one-tailed, power = 0.80 -> MDES = 2.486475 / 5 = 0.4973 -> 0.498
  expect_output(
    pls_sem_power(method = "sensitivity", N = 25, alpha = 0.05, tails = 1, power = 0.80),
    "detect effects as small as 0.498"
  )

  # N = 100, alpha = 0.05, one-tailed, power = 0.80 -> MDES = 2.486475 / 10 = 0.2486 -> 0.249
  expect_output(
    pls_sem_power(method = "sensitivity", N = 100, alpha = 0.05, tails = 1, power = 0.80),
    "detect effects as small as 0.249"
  )
})

test_that("custom power argument behaves correctly", {
  # Power = 0.90, alpha = 0.05, one-tailed -> z(0.95) + z(0.90) = 1.64485 + 1.28155 = 2.9264
  # At MDES = 0.5: required N = (2.9264 / 0.5)^2 = 34.25 -> 35
  expect_output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.05, tails = 1, power = 0.90),
    "you need at least 35 observations"
  )
})

test_that("small sample size warnings are issued when N <= 10", {
  # Sensitivity warning when N <= 10
  expect_warning(
    pls_sem_power(method = "sensitivity", N = 10, alpha = 0.05),
    "inverse square root method is not recommended for sample sizes of 10 or fewer"
  )

  # A priori warning when required N <= 10 (e.g. large MDES = 0.8 at alpha = 0.05, tails = 1)
  expect_warning(
    pls_sem_power(method = "a priori", MDES = 0.8, alpha = 0.05),
    "inverse square root method is not recommended for sample sizes of 10 or fewer"
  )
})

test_that("input validation catches invalid arguments", {
  # Invalid alpha
  expect_error(pls_sem_power(alpha = 0.03), "alpha must be one of: 0.01, 0.05, or 0.10")

  # Invalid tails
  expect_error(pls_sem_power(tails = 3), "tails must be either 1 or 2")

  # Invalid power
  expect_error(pls_sem_power(power = 0), "power must be a single numeric value between 0 and 1")
  expect_error(pls_sem_power(power = 1), "power must be a single numeric value between 0 and 1")
  expect_error(pls_sem_power(power = -0.5), "power must be a single numeric value between 0 and 1")
  expect_error(pls_sem_power(power = "high"), "power must be a single numeric value between 0 and 1")

  # Missing required arguments
  expect_error(pls_sem_power(method = "a priori", MDES = NULL), "You must provide MDES")
  expect_error(pls_sem_power(method = "sensitivity", N = NULL), "You must provide N")

  # Invalid N (sensitivity)
  for (bad_N in list(0, -5, 12.5, NA, Inf, "50", c(25, 50))) {
    expect_error(pls_sem_power(method = "sensitivity", N = bad_N), "N must be a single positive integer")
  }

  # Invalid MDES (a priori)
  for (bad_MDES in list(0, -0.3, NA, Inf, "0.5", c(0.2, 0.5))) {
    expect_error(pls_sem_power(method = "a priori", MDES = bad_MDES), "MDES must be a single positive number")
  }
})

test_that("tail argument works as an explicit alias for tails", {
  # Check that tail = 2 produces same output as tails = 2
  out_tails <- capture.output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.05, tails = 2, power = 0.80)
  )
  out_tail <- capture.output(
    pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.05, tail = 2, power = 0.80)
  )
  expect_equal(out_tails, out_tail)

  # Check error when both tails and tail are given with conflicting values
  expect_error(
    pls_sem_power(method = "a priori", MDES = 0.5, tails = 1, tail = 2),
    "conflicting values"
  )
})


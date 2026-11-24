test_that("pls_sem_power_graph returns ggplot objects for a priori method", {
  p_default <- pls_sem_power_graph(method = "a priori", MDES = 0.5, alpha = 0.05, tails = 1, power = 0.80)
  expect_s3_class(p_default, "ggplot")

  # Themes
  p_min <- pls_sem_power_graph(method = "a priori", MDES = 0.5, theme = "min")
  expect_s3_class(p_min, "ggplot")

  p_pr <- pls_sem_power_graph(method = "a priori", MDES = 0.5, theme = "pr")
  expect_s3_class(p_pr, "ggplot")

  p_abyss <- pls_sem_power_graph(method = "a priori", MDES = 0.5, theme = "abyss")
  expect_s3_class(p_abyss, "ggplot")
})

test_that("pls_sem_power_graph returns ggplot objects for sensitivity method", {
  p_sens <- pls_sem_power_graph(method = "sensitivity", N = 100, alpha = 0.05, tails = 2, power = 0.80)
  expect_s3_class(p_sens, "ggplot")
})

test_that("pls_sem_power_graph validates input arguments", {
  expect_error(pls_sem_power_graph(method = "invalid"), "Invalid method")
  expect_error(pls_sem_power_graph(method = "a priori", MDES = NULL), "provide a value for MDES")
  expect_error(pls_sem_power_graph(method = "sensitivity", N = NULL), "provide a value for N")
  expect_error(pls_sem_power_graph(alpha = 0.02), "alpha must be one of")
  expect_error(pls_sem_power_graph(tails = 3), "tails must be either 1 or 2")
  expect_error(pls_sem_power_graph(power = 1.2), "power must be a single numeric value between 0 and 1")

  for (bad_N in list(0, -5, 12.5, NA, "50")) {
    expect_error(pls_sem_power_graph(method = "sensitivity", N = bad_N), "N must be a single positive integer")
  }
  for (bad_MDES in list(0, -0.3, NA, "0.5")) {
    expect_error(pls_sem_power_graph(method = "a priori", MDES = bad_MDES), "MDES must be a single positive number")
  }
})

test_that("pls_sem_power_graph accepts tail as alias for tails", {
  p_tails <- pls_sem_power_graph(method = "a priori", MDES = 0.5, tails = 2)
  p_tail <- pls_sem_power_graph(method = "a priori", MDES = 0.5, tail = 2)
  expect_s3_class(p_tail, "ggplot")
  expect_equal(p_tails$labels$subtitle, p_tail$labels$subtitle)

  expect_error(
    pls_sem_power_graph(method = "a priori", MDES = 0.5, tails = 1, tail = 2),
    "conflicting values"
  )
})

test_that("pls_sem_power_graph produces warning when sample size <= 10", {
  expect_warning(
    pls_sem_power_graph(method = "sensitivity", N = 10),
    "inverse square root method is not recommended for sample sizes of 10 or fewer"
  )
})

# plssempower

An R package for computing power and sensitivity analyses in Partial Least Squares Structural Equation Modeling (PLS-SEM) using the inverse square root method.

## 🚀 What does this package do?

This package provides two simple functions:

- `pls_sem_power()` – Computes either the **minimum sample size** needed for a given Minimum Detectable Effect Size (MDES), or the **MDES** for a given sample size, based on the formula proposed by Kock & Hadaya (2018).
- `pls_sem_power_graph()` – Generates ggplot2 graphs showing the relationship between MDES and sample size, including reference lines for the user’s input.

## 📊 Methodology

The package is based on the **inverse square root method**, introduced by Kock & Hadaya (2018), which is a practical approach for determining sample sizes in PLS-SEM. The key formula used is:


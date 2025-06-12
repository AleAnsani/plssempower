# PLS-SEM-power

Stressed about sample size in your Partial Least Squares Structural Equation Model?
Planning a PLS-SEM, but unsure how many participants you need?
Worried that your expected effect size is small and your sample might be...even smaller?
Still relying on vague heuristics like the “10-times rule”?
We’ve all been there. Well, not exactly "all", to be fair...

Say hello to `plssempower`, an R package designed to make power analysis for PLS-SEM models fast, transparent, and reproducible.
Using the inverse square root method introduced by Kock and Hadaya (2018), this package lets you:

- Compute the required sample size for a given effect size (_a priori_)
- Compute the Minimum Detectable Effect Size (MDES) for a given sample (_sensitivity_)

Visualise your results with clear, (slightly) customizable graphs
All in one function. No more guessing. No more excuses.

## Install from GitHub
The installation is pretty easy. Make sure to run this code:
 ```r
# install.packages("devtools")
# install plssempower
devtools::install_github("AleAnsani/plssempower")
 ```

## 🚀 What does this package do?
`plssempower` is an R package for computing power and sensitivity analyses in Partial Least Squares Structural Equation Modelling (PLS-SEM) using the inverse square root method.

This package provides two simple functions:

- `pls_sem_power()` – Computes either the **minimum sample size** needed for a given Minimum Detectable Effect Size (MDES), or the **MDES** for a given sample size, based on the formula proposed by Kock & Hadaya (2018).
- `pls_sem_power_graph()` – Generates ggplot2 graphs showing the relationship between MDES and sample size, including reference lines for the user’s input.

## 📊 Methodology

The package is based on the **inverse square root method**, introduced by Kock & Hadaya (2018), which is a practical approach for determining sample sizes in PLS-SEM. The key formula used is:
N = (pα / pmin)^2


Where:
- `pα` is a constant depending on the significance level (α = 0.01, 0.05, 0.10),
- `pmin` is the path coefficient with minimum magnitude expected to be significant.

## 🔧 Usage

```r
# Compute the required sample size for a given MDES
pls_sem_power(method = "a priori", MDES = 0.2, alpha = 0.05)

# Compute MDES for a given sample size
pls_sem_power(method = "sensitivity", N = 63, alpha = 0.05)

# Generate graph (a priori)
pls_sem_power_graph(method = "a priori", MDES = 0.2, alpha = 0.05)

# Generate graph (sensitivity)
pls_sem_power_graph(method = "sensitivity", N = 63, alpha = 0.05)
```
_Notes_:
- The alpha argument accepts only three values: 0.01, 0.05, and 0.10.
- When using `pls_sem_power_graph`, you can set `theme = "min"` to apply a minimal white background, which may improve readability in certain contexts.

## 🔧 Examples
### A priori
Let's assume that you need to collect your sample and you're interested in one particular path of your PLS-SEM, whose effect size you estimate to be around 0.5.
In this case, you would conduct an _a priori_ power analysis to assess the minimum required sample size to observe such an effect with 80% power.

All you need to run is
```r
pls_sem_power_graph(method = "a priori", MDES = 0.5, alpha = 0.05)
```
This graph will appear, clearly showing that you would need at least **25 participants** to observe such an effect with 80% power 
![image](https://github.com/user-attachments/assets/3f4bd5f6-7cdd-4795-8d3e-ca914e80b3bd)

If you're not interested in the graph, but you just need to have the computation done, then you simply need to run
 ```r
pls_sem_power(method = "a priori", MDES = 0.5, alpha = 0.05)
```
And you'll receive this message
 ```r
To detect an effect of 0.5 with 80% power at alpha = 0.05 you need at least 25 observations.
 ```

### Sensitivity
Let's now assume that you have already collected your sample, prior to any power analysis (Aargh! Naughty researcher!). You have painstakingly gathered 77 participants, and you're starting to wonder what the smallest effect size is that you could detect with 80% power.
In this case, you would conduct a _sensitivity_ power analysis to assess the Minimum Detectable Effect Size (MDES) with 80% power given your sample size.

All you need to run is
```r
pls_sem_power_graph(method = "sensitivity", N = 77, alpha = 0.05)
```
This graph will appear, telling you that you can detect effects larger than **0.28** with 80% power 
![image](https://github.com/user-attachments/assets/3391f06e-1ed5-4fb9-9cd5-0bfbc6f79a2f)


Again, if you're rushing and don't really care about the graph, then you simply need to type
 ```r
pls_sem_power(method = "sensitivity", N = 77, alpha = 0.05)
```
And you'll receive this message
 ```r
With N = 77 and alpha = 0.05 you can detect effects as small as 0.28 with 80% power
 ```

Easy-peasy...isn't it?!

## 📚 References
Kock, N., & Hadaya, P. (2018). Minimum sample size estimation in PLS‐SEM: The inverse square root and gamma‐exponential methods. _Information Systems Journal, 28_(1), 227–261.

Bloom, H. S. (1995). Minimum Detectable Effects: A Simple Way to Report the Statistical Power of Experimental Designs. _Evaluation Review, 19_(5), 547–556.

Dong, N., & Maynard, R. (2013). PowerUp!: A Tool for Calculating Minimum Detectable Effect Sizes and Minimum Required Sample Sizes. _Journal of Research on Educational Effectiveness, 6_(1), 24–67.




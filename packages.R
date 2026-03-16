# packages.R — R package requirements for ECO1400_Project_Metric
# Purpose: Install all required packages for running analyses
# Usage: source("packages.R")

required_packages <- c(
  # Data manipulation & import
  "readr",
  "dplyr",
  "tidyr",
  "tibble",

  # Time series & ML models
  "tseries",    # ADF test for stationarity
  "vars",       # VAR models
  "tsDyn",      # Dynamic time series analysis
  "xts",        # Extended time series
  "zoo",        # S3 infrastructure for regular and irregular time series

  # Machine learning
  "ranger",     # Fast Random Forest
  "randomForest",  # Classic Random Forest
  "quantregForest", # Quantile regression forests
  "BART",       # Bayesian Additive Regression Trees
  "dbarts",     # Discrete Bayesian Additive Regression Trees
  "BVAR",       # Bayesian VAR

  # Visualization & reporting
  "ggplot2",
  "lubridate",  # Date handling
  "scales",     # Graphical scales
  "knitr",      # Dynamic document generation
  "tinytex",    # LaTeX for PDF output

  # Project structure & package management
  "here",       # Relative file paths
  "librarian"   # Package shelf management
)

# Install librarian first if needed (used to manage other packages)
if (!requireNamespace("librarian", quietly = TRUE)) {
  install.packages("librarian")
}

# Install and load all packages via librarian
librarian::shelf(required_packages, quietly = TRUE)

# Ensure TinyTeX is installed for PDF rendering
if (!requireNamespace("tinytex", quietly = TRUE)) {
  install.packages("tinytex")
}
if (Sys.which("pdflatex") == "") {
  message("Installing TinyTeX for PDF generation...")
  tinytex::install_tinytex()
}

message("✓ All packages loaded successfully")

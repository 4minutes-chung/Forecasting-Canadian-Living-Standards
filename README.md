# ECO1400 Project: Canadian Macroeconomic Forecasting

A comparative analysis of macroeconomic forecasting methods applied to Canadian economic indicators using **Vector Autoregression (VAR)**, **Random Forest (RF)**, and **Bayesian Additive Regression Trees (BART)**.

---

## Overview

This project compares three machine learning and statistical approaches to forecast three key Canadian macroeconomic variables:
- **GDP per worker growth rate**
- **Consumer Price Index (CPI)**
- **National house prices**

Using the CAN-MD dataset (Fortin-Gagnon et al., 2018), the analysis evaluates forecast accuracy via time-series cross-validation and produces detailed performance comparisons and visualizations.

---

## Project Structure

```
1400_Project_Metric/
├── README.md                        # This file
├── packages.R                       # Install all R package dependencies
│
├── Rmd_files/                             # Source R and Rmd analysis scripts
│   ├── 01_VAR_model.Rmd            # Baseline VAR model & validation
│   ├── 02_RF_cv.Rmd                # Random Forest with time-series cross-validation
│   ├── 03_RF_application.Rmd       # RF applied to forecast targets
│   ├── 04_BART_kaggle_cv.Rmd       # BART CV (originally from Kaggle)
│   ├── 04b_BART_kaggle_cv.ipynb    # Jupyter notebook version of BART CV
│   ├── 05_BART_application.Rmd     # BART applied to forecast targets
│   ├── 06_results_tables_graphs.Rmd # Final results, tables, and visualizations
│   ├── 07_BVAR_exploratory.Rmd     # Bayesian VAR exploratory analysis
│   
│
├── data/                            # Input data
│   ├── raw/                         # Original source files
│   │   ├── balanced_can_md.csv     # Main CAN-MD dataset
│   │   ├── CAN_MD.csv              # Unbalanced version
│   │   ├── TR_CAN_MD.csv           # Transformed version
│   │   ├── Table_can_md.xlsx       # Excel format
│   │   └── README_data.txt         # Data documentation
│   └── intermediate/                # Processed data (subsets, training/test splits)
│       ├── df_subset.csv
│       └── project_subset.csv
│
├── outputs/                         # Generated outputs
│   ├── forecasts/                  # Model forecast CSV files
│   ├── reports/                    # Rendered PDF reports
│   └── notebooks/                  # HTML notebooks
│
├── paper/                           # Final deliverable
    └── ECO1400_Term_Paper_Steven_Victor.pdf

```

---

## Getting Started

### 1. Install Dependencies

```r
source("packages.R")
```

This will install all required R packages (tidyverse, vars, ranger, BART, etc.) and TinyTeX for PDF rendering.

### 2. Run the Analysis

Execute the scripts in order:

| Step | Script | Purpose | Runtime |
|------|--------|---------|---------|
| 1 | `src/01_VAR_model.Rmd` | Baseline VAR model & stationarity tests | ~2 min |
| 2 | `src/02_RF_cv.Rmd` | Random Forest time-series CV | ~15 min |
| 3 | `src/03_RF_application.Rmd` | RF forecasts on full dataset | ~3 min |
| 4 | `src/04_BART_kaggle_cv.Rmd` | BART time-series CV | **~3 hours** ⏱️ |
| 5 | `src/05_BART_application.Rmd` | BART forecasts on full dataset | ~5 min |
| 6 | `src/07_BVAR_exploratory.Rmd` | Bayesian VAR exploration | ~10 min |
| 7 | `src/06_results_tables_graphs.Rmd` | Aggregate results & visualizations | ~5 min |

**Note**: Step 4 is computationally intensive. It was originally run on Kaggle. For local execution, reduce CV folds or use a subset of features.

---

## Dataset: CAN-MD

**Citation**: Fortin-Gagnon, O., Lermer, K., Massé, J., & Morin, S. (2018). A Large Bayesian Vector Autoregression Model for Canada's Economy. *Bank of Canada Review*.

The CAN-MD is a large macro dataset for Canada containing monthly observations of:
- Real economic activity (GDP by sector, employment)
- Inflation indicators (CPI, producer prices)
- Financial variables (interest rates, exchange rates)
- Housing market data (starts, prices)
- External sector data (exports, imports, commodity prices)

**Data location**: `data/raw/balanced_can_md.csv`

---

## Key Features & Methodology

### Time-Series Cross-Validation
All models use walk-forward cross-validation to avoid lookahead bias:
- Training window: 120 months
- Forecast horizon: 6 months ahead
- Step size: 12 months

### Models Compared

1. **VAR (Vector Autoregression)**
   - Linear, interpretable baseline
   - Captures contemporaneous and lagged relationships
   - Script: `src/01_VAR_model.Rmd`

2. **Random Forest**
   - Non-linear, ensemble method
   - Feature importance ranking
   - Scripts: `src/02_RF_cv.Rmd`, `src/03_RF_application.Rmd`

3. **BART (Bayesian Additive Regression Trees)**
   - Bayesian tree ensemble with uncertainty quantification
   - Naturally handles non-linearity and interactions
   - Scripts: `src/04_BART_kaggle_cv.Rmd`, `src/05_BART_application.Rmd`

4. **BVAR (Bayesian VAR)**
   - Bayesian alternative to VAR with shrinkage priors
   - Script: `src/07_BVAR_exploratory.Rmd`

---

## Outputs

### Forecast Files (in `outputs/forecasts/`)
- `BART_forecasts_short.csv`, `BART_forecasts_long.csv` — BART predictions
- `RF_all_variables_*.csv` — Random Forest predictions
- `VAR_large_all_variables_*.csv` — VAR predictions
- `Model_Comparison_RMSE.csv` — Cross-model accuracy comparison

### Reports (in `outputs/reports/`)
- `01_VAR_model.pdf` — VAR estimation & diagnostics
- `02_RF_cv.pdf` — Random Forest CV results
- `03_RF_application.pdf` — RF forecast results
- `04_BART_kaggle_cv.pdf` — BART CV results
- `05_BART_application.pdf` — BART forecast results
- `06_results_tables_graphs.pdf` — **Main results summary** (tables, plots, model comparison)
- `BVAR.pdf` — Bayesian VAR exploration

---

## Configuration

### File Paths
All scripts use `here::here()` for portable, relative file paths. Set the working directory to the project root in RStudio (or via `setwd()`).

### Rmd Output Format
Each Rmd can render to PDF, HTML, or Word. Default is PDF. Modify the YAML header in any `.Rmd` file to change:
```yaml
output:
  pdf_document: default    # Change to html_document or word_document
```

---

## Code Organization

### Main Functions

**`build_lagged_panel(df, predictors, targets, p, h)`** (in `src/05_BART_application.Rmd`)
- Constructs lagged predictor matrix for time-series prediction
- Arguments:
  - `df`: dataframe with Date column and feature/target columns
  - `predictors`: vector of column names to lag
  - `targets`: vector of columns to forecast
  - `p`: number of lags (usually 3–6)
  - `h`: forecast horizon in months (6 for this project)
- Returns: `list(X = feature_matrix, Y = target_matrix)`

**`rf_ts_cv_rmse()` and `bart_ts_cv_rmse()`** (in respective `.Rmd` files)
- Time-series cross-validation with RMSE evaluation
- Walk-forward setup: no lookahead bias

**`plot_functions.R`**
- `plot_function()` — Generic time-series forecast plot
- `plot_VAR_VEC_function()` — VAR vector error correction plot

---

## Common Issues & Notes

### Kaggle Path Issue
`src/04_BART_kaggle_cv.Rmd` was originally developed on Kaggle and contains hard-coded paths.
Updated for local use, but runtime is long (~3 hours). Consider:
- Reducing CV folds (`K = 5` instead of `K = 10`)
- Using a feature subset
- Running on a high-performance machine

### Missing Outputs
If you get a "file not found" error when knitting:
1. Verify `working directory` is set to the project root
2. Run `source("packages.R")` to ensure all packages are loaded
3. Run scripts sequentially (output from step N is input to step N+1)

---

## Contact & Attribution

**Author**: Steven Victor
**Course**: ECO1400 (Econometrics Project)
**Date**: December 2025

See `references/core/` for all cited academic sources.

---

## License

This project includes academic analysis and code. Use for educational and research purposes. See individual reference papers for their respective licenses.

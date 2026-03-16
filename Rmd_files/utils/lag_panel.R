#' Build Lagged Panel for Time-Series Prediction
#'
#' Constructs a lagged feature matrix and target matrix for supervised learning
#' on time-series data. Used for training VAR, RF, and BART models.
#'
#' @param df A data frame with a 'Date' column and feature/target columns
#' @param predictors A vector of column names to use as features (will be lagged)
#' @param targets A vector of column names to forecast
#' @param p Number of lags to create (e.g., p=3 creates lags 1, 2, 3)
#' @param h Forecast horizon in periods (e.g., h=6 for 6-month ahead)
#'
#' @details
#' The function creates p lags of each predictor and h-step-ahead leads of each target.
#' Missing values are removed via drop_na().
#'
#' @return A list with two components:
#'   \item{X}{Feature matrix (n_samples × p*n_predictors), suitable for train()}
#'   \item{Y}{Target matrix (n_samples × n_targets), columns in same order as 'targets' arg}
#'
#' @examples
#' # Suppose df has columns: Date, GDP, CPI, NHOUSE_P, IP, etc.
#' # Create lagged panel with 3 lags, 6-month forecast horizon
#' panel <- build_lagged_panel(
#'   df = df_ml,
#'   predictors = c("GDP_per_w", "CPI_ALL_CAN", "IP_new"),
#'   targets = c("GDP_per_w", "CPI_ALL_CAN", "NHOUSE_P_CAN"),
#'   p = 3,
#'   h = 6
#' )
#'
#' X <- panel$X  # Feature matrix for training
#' Y <- panel$Y  # Target matrix for training
#'
build_lagged_panel <- function(df, predictors, targets, p, h) {
  # Select and arrange data
  dat <- df %>%
    dplyr::select(Date, dplyr::all_of(unique(c(predictors, targets)))) %>%
    dplyr::arrange(Date)

  # Create lagged features
  for (lag in 1:p) {
    for (v in predictors) {
      new_name <- paste0("L", lag, "_", v)
      dat[[new_name]] <- dplyr::lag(dat[[v]], lag)
    }
  }

  # Create forward-looking targets (leads)
  for (v in targets) {
    lead_name <- paste0("F", h, "_", v)
    dat[[lead_name]] <- dplyr::lead(dat[[v]], h)
  }

  # Select lagged predictors and forward targets
  lag_cols <- grep("^L[0-9]+_", names(dat), value = TRUE)
  y_cols   <- paste0("F", h, "_", targets)

  # Drop rows with NAs and extract matrices
  dat_final <- dat %>%
    dplyr::select(dplyr::all_of(c(lag_cols, y_cols))) %>%
    tidyr::drop_na()

  list(
    X = as.matrix(dat_final[, lag_cols, drop = FALSE]),
    Y = as.matrix(dat_final[, y_cols,  drop = FALSE])  # columns in same order as targets
  )
}

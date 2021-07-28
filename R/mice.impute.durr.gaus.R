#' Imputation by lasso linear regression, bootstrap method (DURR)
#'
#' Imputes univariate missing data using lasso linear regression with bootstrap
#'
#' @aliases mice.impute.durr.gaus durr.gaus
#' @inheritParams mice.impute.pmm
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @details
#' Draws a bootstrap sample from \code{x} and \code{y}, trains a
#' penalised lasso regression and imputes with normal residuals.
#' @author Edoardo Costantini, 2021
#' @references Deng et. al. (2016)
#' @family univariate imputation functions
#' @keywords datagen
#' @export
mice.impute.durr.gaus <- function(y, ry, x, wy = NULL, ...) {
  # Bootstrap sample
  if (is.null(wy)) wy <- !ry
  idx_bs  <- sample(1:length(y), length(y), replace = TRUE)
  y_star  <- y[idx_bs]
  ry_star <- ry[idx_bs]
  wy_star <- wy[idx_bs]
  x_star <- x[idx_bs, ]
  
  # Prepare data for imputation model
  xobs <- x_star[ry_star, , drop = FALSE]
  xmis <- x_star[wy_star, , drop = FALSE]
  yobs <- y_star[ry_star]

  # Train imputation model
  cv_lasso <- glmnet::cv.glmnet(xobs, yobs,
                                family = "gaussian",
                                nfolds = 10,
                                alpha = 1)

  # Obtain imputation
  s2hat   <- mean((predict(cv_lasso, xobs) - yobs)**2)
  as.vector(predict(cv_lasso, xmis, s = "lambda.min")) + rnorm(nrow(xmis), 0, sqrt(s2hat))
}

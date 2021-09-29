#' Imputation by lasso linear regression, bootstrap method (DURR)
#'
#' Imputes univariate missing data using lasso linear regression with bootstrap
#'
#' @aliases mice.pcr.sim.impute.durr.gaus durr.gaus
#' @inheritParams mice.pcr.sim.impute.pmm
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @details
#' Draws a bootstrap sample from \code{x} and \code{y}, trains a
#' penalised lasso regression and imputes with normal residuals.
#' @author Edoardo Costantini, 2021
#' @references
#'
#' Deng, Y., Chang, C., Ido, M. S., & Long, Q. (2016). Multiple imputation for
#' general missing data patterns in the presence of high-dimensional data.
#' Scientific reports, 6(1), 1-10.
#'
#' @family univariate imputation functions
#' @keywords datagen
#' @export
mice.pcr.sim.impute.durr.gaus <- function(y, ry, x, wy = NULL, ...) {
  # Bootstrap sample
  if (is.null(wy)) wy <- !ry
  n1 <- sum(ry)
  s <- sample(n1, n1, replace = TRUE)
  dotxobs <- x[ry, , drop = FALSE][s, ]
  dotyobs <- y[ry][s]

  # Train imputation model
  cv_lasso <- glmnet::cv.glmnet(x = dotxobs, y = dotyobs,
                                family = "gaussian",
                                nfolds = 10,
                                alpha = 1)

  # Obtain imputation
  s2hat   <- mean((predict(cv_lasso, dotxobs) - dotyobs)^2)
  as.vector(predict(cv_lasso, x[wy, ], s = "lambda.min")) +
    rnorm(sum(wy), 0, sqrt(s2hat))
}

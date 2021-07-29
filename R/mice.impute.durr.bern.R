#' Imputation by lasso logistic regression, bootstrap method (DURR)
#'
#' Imputes univariate missing data using lasso logistic regression with bootstrap
#'
#' @aliases mice.impute.durr.bern durr.bern
#' @inheritParams mice.impute.pmm
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @details
#' Draws a bootstrap sample from \code{x} and \code{y}, trains a
#' penalised lasso logistic regression and imputes from bernoulli predictive
#' distribution.
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
mice.impute.durr.bern <- function(y, ry, x, wy = NULL, ...) {
  # Bootstrap sample
  if (is.null(wy)) wy <- !ry
  idx_bs  <- sample(seq_along(y), length(y), replace = TRUE)
  y_star  <- y[idx_bs]
  ry_star <- ry[idx_bs]
  x_star <- x[idx_bs, ]

  # Prepare data for imputation model
  xobs <- x_star[ry_star, , drop = FALSE]
  xmis <- x[wy, , drop = FALSE]
  yobs <- y_star[ry_star]

  # Train imputation model
  cv_lasso <- glmnet::cv.glmnet(xobs, yobs,
                                family = "binomial",
                                nfolds = 10,
                                alpha = 1)

  # Obtain imputation
  p <- 1 / (1 + exp(predict(cv_lasso, xmis, s = "lambda.min")))
  vec <- (runif(nrow(p)) <= p)
  vec[vec] <- 1
  if (is.factor(y)) {
    vec <- factor(vec, c(0, 1), levels(y))
  }
  vec
}

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
  p <- 1 / (1 + exp(predict(cv_lasso, x[wy, ], s = "lambda.min")))
  vec <- (runif(nrow(p)) <= p)
  vec[vec] <- 1
  if (is.factor(y)) {
    vec <- factor(vec, c(0, 1), levels(y))
  }
  vec
}

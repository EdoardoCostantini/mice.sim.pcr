#' Imputation by principal component regression
#'
#' Imputes univariate missing data using principal component regression.
#'
#' @aliases mice.impute.pcr.boot pcr.boot
#' @inheritParams mice.impute.pmm
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @details
#' Extracts components from x and uses them as predictors the regular
#' norm.boot() fashion.
#' @author Edoardo Costantini, 2021
#' @references
#'
#' Howard, W. J., Rhemtulla, M., & Little, T. D. (2015). Using principal components
#' as auxiliary variables in missing data estimation. Multivariate Behavioral Research,
#' 50(3), 285-299.
#'
#' @family univariate imputation functions
#' @keywords datagen
#' @export
mice.impute.pcr.boot <- function(y, ry, x, wy = NULL, ...) {
  if (is.null(wy)) wy <- !ry

  # Parameter uncertainty (through bootsrap)
  n1 <- sum(ry)
  s <- sample(n1, n1, replace = TRUE)
  dotxobs <- x[ry, , drop = FALSE][s, ]
  dotyobs <- y[ry][s]

  # Fit PCR
  pcr_model <- pls::pcr(dotyobs ~ .,
                        data = data.frame(dotyobs, dotxobs),
                        validation = "CV")
  ncomp <- selectNcomp(pcr_model, "onesigma", plot = FALSE)

  # Predict
  pcr_pred <- predict(pcr_model, x[wy, ], ncomp = ncomp)

  # Noise
  sigma <- sqrt(mean(pcr_model$residuals^2))
  pcr_pred + rnorm(sum(wy)) * sigma
}
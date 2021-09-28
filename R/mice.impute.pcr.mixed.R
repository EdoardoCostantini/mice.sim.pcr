#' Imputation by principal component regression
#'
#' Imputes univariate missing data by extracting PCs from all auxiliary variables.
#' This version uses a correlation matrix estiamted with the mixedCor()
#' for a mixture of tetrachorics, polychorics, Pearsons, biserials, and polyserials,
#' as appropriate.
#'
#' @aliases mice.impute.pcr.mixed pcr.mixed
#' @inheritParams mice.impute.pmm
#' @param npcs The number of principal components to extract with the pcr.mixed method.
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @details
#' Extracts components from x and uses them as predictors the regular
#' norm.boot() fashion.
#' @author Edoardo Costantini, 2021
#' @references
#'
# 'Revelle W (2021). psych: Procedures for Psychological, Psychometric, and Personality
#  Research. Northwestern University, Evanston, Illinois. R package version 2.1.6,
#  https://CRAN.R-project.org/package=psych.
#' Jolliffe, I. (2002) Principal Component Analysis (2nd ed). Springer.
#'
#' @family univariate imputation functions
#' @keywords datagen
#' @export
mice.impute.pcr.mixed <- function(y, ry, x, wy = NULL, npcs, ...) {
  if (is.null(wy)) wy <- !ry

  # Get PCs
  pcr_out <- stats::prcomp(x,
                           center = TRUE,
                           scale = TRUE)

  # Compute Explained Variance by each principal component
  pc_var_exp <- prop.table(pcr_out$sdev^2)

  # Keep PCs based on npcs object
  if(npcs >= 1){
    # npcs as NOT-a-proportion
    pcs_keep <- 1:npcs
    x_pcs <- pcr_out$x[, pcs_keep, drop = FALSE]
  } else {
    # npcs as a proportion
    pcs_keep <- cumsum(pc_var_exp) <= npcs
    x_pcs <- pcr_out$x[, pcs_keep, drop = FALSE]
  }

  # Use traditional norm.boot machinery to obtain prediction
  x <- cbind(1, as.matrix(x_pcs))
  n1 <- sum(ry)
  s <- sample(n1, n1, replace = TRUE)
  ss <- s
  dotxobs <- x[ry, , drop = FALSE][s, ]
  dotyobs <- y[ry][s]
  p <- estimice(dotxobs, dotyobs, ...)
  sigma <- sqrt((sum(p$r^2)) / (n1 - ncol(x) - 1))
  x[wy, ] %*% p$c + rnorm(sum(wy)) * sigma
}
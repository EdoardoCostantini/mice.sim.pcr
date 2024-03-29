#' Imputation at level 2 by Bayesian linear regression
#'
#' Imputes univariate missing data at level 2 using Bayesian linear regression
#' analysis.  Variables are level 1 are aggregated at level 2. The group
#' identifier at level 2 must be indicated by \code{type = -2} in the
#' \code{predictorMatrix}.
#'
#' @aliases 2lonly.norm
#' @inheritParams mice.pcr.sim.impute.pmm
#' @param type Group identifier must be specified by '-2'. Predictors must be
#' specified by '1'.
#' @param ... Other named arguments.
#' @return A vector of length \code{nmis} with imputations.
#' @author Alexander Robitzsch (IPN - Leibniz Institute for Science and
#' Mathematics Education, Kiel, Germany), \email{robitzsch@@ipn.uni-kiel.de}
#' @seealso \code{\link{mice.pcr.sim.impute.norm}},
#' \code{\link{mice.pcr.sim.impute.2lonly.pmm}}, \code{\link{mice.pcr.sim.impute.2l.pan}},
#' \code{\link{mice.pcr.sim.impute.2lonly.mean}}
#' @details
#' This function allows in combination with \code{\link{mice.pcr.sim.impute.2l.pan}}
#' switching regression imputation between level 1 and level 2 as described in
#' Yucel (2008) or Gelman and Hill (2007, p. 541).
#'
#' The function checks for partial missing level-2 data. Level-2 data
#' are assumed to be constant within the same cluster. If one or more
#' entries are missing, then the procedure aborts with an error
#' message that identifies the cluster with incomplete level-2 data.
#' In such cases, one may first fill in the cluster mean (or mode) by
#' the \code{2lonly.mean} method to remove inconsistencies.
#'
#' @references Gelman, A. and Hill, J. (2007). \emph{Data analysis using
#' regression and multilevel/hierarchical models}. Cambridge, Cambridge
#' University Press.
#'
#' Yucel, RM (2008). Multiple imputation inference for multivariate multilevel
#' continuous data with ignorable non-response.  \emph{Philosophical
#' Transactions of the Royal Society A}, \bold{366}, 2389-2404.
#'
#' Van Buuren, S. (2018).
#' \href{https://stefvanbuuren.name/fimd/sec-level2pred.html}{\emph{Flexible Imputation of Missing Data. Second Edition.}}
#' Chapman & Hall/CRC. Boca Raton, FL.
#' @family univariate-2lonly
#' @note
#' For a more general approach, see
#' \code{miceadds::mice.pcr.sim.impute.2lonly.function()}.
#' @examples
#' # simulate some data
#' # x,y ... level 1 variables
#' # v,w ... level 2 variables
#'
#' G <- 250 # number of groups
#' n <- 20 # number of persons
#' beta <- .3 # regression coefficient
#' rho <- .30 # residual intraclass correlation
#' rho.miss <- .10 # correlation with missing response
#' missrate <- .50 # missing proportion
#' y1 <- rep(rnorm(G, sd = sqrt(rho)), each = n) + rnorm(G * n, sd = sqrt(1 - rho))
#' w <- rep(round(rnorm(G), 2), each = n)
#' v <- rep(round(runif(G, 0, 3)), each = n)
#' x <- rnorm(G * n)
#' y <- y1 + beta * x + .2 * w + .1 * v
#' dfr0 <- dfr <- data.frame("group" = rep(1:G, each = n), "x" = x, "y" = y, "w" = w, "v" = v)
#' dfr[rho.miss * x + rnorm(G * n, sd = sqrt(1 - rho.miss)) < qnorm(missrate), "y"] <- NA
#' dfr[rep(rnorm(G), each = n) < qnorm(missrate), "w"] <- NA
#' dfr[rep(rnorm(G), each = n) < qnorm(missrate), "v"] <- NA
#'
#' # empty mice.pcr.sim imputation
#' imp0 <- mice.pcr.sim(as.matrix(dfr), maxit = 0)
#' predM <- imp0$predictorMatrix
#' impM <- imp0$method
#'
#' # multilevel imputation
#' predM1 <- predM
#' predM1[c("w", "y", "v"), "group"] <- -2
#' predM1["y", "x"] <- 1 # fixed x effects imputation
#' impM1 <- impM
#' impM1[c("y", "w", "v")] <- c("2l.pan", "2lonly.norm", "2lonly.pmm")
#'
#' # y ... imputation using pan
#' # w ... imputation at level 2 using norm
#' # v ... imputation at level 2 using pmm
#'
#' imp1 <- mice.pcr.sim(as.matrix(dfr),
#'   m = 1, predictorMatrix = predM1,
#'   method = impM1, maxit = 1, paniter = 500
#' )
#'
#' # Demonstration that 2lonly.norm aborts for partial missing data.
#' # Better use 2lonly.mean for repair.
#' data <- data.frame(
#'   patid = rep(1:4, each = 5),
#'   sex = rep(c(1, 2, 1, 2), each = 5),
#'   crp = c(
#'     68, 78, 93, NA, 143,
#'     5, 7, 9, 13, NA,
#'     97, NA, 56, 52, 34,
#'     22, 30, NA, NA, 45
#'   )
#' )
#' pred <- make.predictorMatrix(data)
#' pred[, "patid"] <- -2
#' # only missing value (out of five) for patid == 1
#' data[3, "sex"] <- NA
#' \dontrun{
#' # The following fails because 2lonly.norm found partially missing
#' # level-2 data
#' # imp <- mice.pcr.sim(data, method = c("", "2lonly.norm", "2l.pan"),
#' #             predictorMatrix = pred, maxit = 1, m = 2)
#' # > iter imp variable
#' # > 1   1  sex  crpError in .imputation.level2(y = y, ... :
#' # >   Method 2lonly.norm found the following clusters with partially missing
#' # >    level-2 data: 1
#' # > Method 2lonly.mean can fix such inconsistencies.
#' }
#'
#' # In contrast, if all sex values are missing for patid == 1, it runs fine,
#' # except on r-patched-solaris-x86. I used dontrun to evade CRAN errors.
#' \dontrun{
#' data[1:5, "sex"] <- NA
#' imp <- mice.pcr.sim(data,
#'   method = c("", "2lonly.norm", "2l.pan"),
#'   predictorMatrix = pred, maxit = 1, m = 2
#' )
#' }
#' @export
mice.pcr.sim.impute.2lonly.norm <- function(y, ry, x, type, wy = NULL, ...) {
  imp <- .imputation.level2(
    y = y, ry = ry, x = x, type = type, wy = wy,
    method = "norm", ...
  )
  imp
}

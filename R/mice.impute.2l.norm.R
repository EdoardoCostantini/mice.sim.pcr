#' Imputation by a two-level normal model
#'
#' Imputes univariate missing data using a two-level normal model
#'
#' Implements the Gibbs sampler for the linear multilevel model with
#' heterogeneous with-class variance (Kasim and Raudenbush, 1998). Imputations
#' are drawn as an extra step to the algorithm. For simulation work see Van
#' Buuren (2011).
#'
#' The random intercept is automatically added in \code{mice.pcr.sim.impute.2L.norm()}.
#' A model within a random intercept can be specified by \code{mice.pcr.sim(...,
#' intercept = FALSE)}.
#'
#' @name mice.pcr.sim.impute.2l.norm
#' @inheritParams mice.pcr.sim.impute.pmm
#' @param type Vector of length \code{ncol(x)} identifying random and class
#' variables.  Random variables are identified by a '2'. The class variable
#' (only one is allowed) is coded as '-2'. Random variables also include the
#' fixed effect.
#' @param intercept Logical determining whether the intercept is automatically
#' added.
#' @param ... Other named arguments.
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @note Added June 25, 2012: The currently implemented algorithm does not
#' handle predictors that are specified as fixed effects (type=1). When using
#' \code{mice.pcr.sim.impute.2l.norm()}, the current advice is to specify all predictors
#' as random effects (type=2).
#'
#' Warning: The assumption of heterogeneous variances requires that in every
#' class at least one observation has a response in \code{y}.
#' @author Roel de Jong, 2008
#' @references
#'
#' Kasim RM, Raudenbush SW. (1998). Application of Gibbs sampling to nested
#' variance components models with heterogeneous within-group variance. Journal
#' of Educational and Behavioral Statistics, 23(2), 93--116.
#'
#' Van Buuren, S., Groothuis-Oudshoorn, K. (2011). \code{mice.pcr.sim}: Multivariate
#' Imputation by Chained Equations in \code{R}. \emph{Journal of Statistical
#' Software}, \bold{45}(3), 1-67. \url{https://www.jstatsoft.org/v45/i03/}
#'
#' Van Buuren, S. (2011) Multiple imputation of multilevel data. In Hox, J.J.
#' and and Roberts, J.K. (Eds.), \emph{The Handbook of Advanced Multilevel
#' Analysis}, Chapter 10, pp. 173--196. Milton Park, UK: Routledge.
#' @family univariate-2l
#' @keywords datagen
#' @export
mice.pcr.sim.impute.2l.norm <- function(y, ry, x, type, wy = NULL, intercept = TRUE, ...) {
  if (intercept) {
    x <- cbind(1, as.matrix(x))
    type <- c(2, type)
  }

  ## Initialize
  n.iter <- 100
  if (is.null(wy)) wy <- !ry
  n.class <- length(unique(x[, type == -2]))
  if (n.class == 0) stop("No class variable")
  gf.full <- factor(x[, type == -2], labels = seq_len(n.class))
  gf <- gf.full[ry]
  XG <- split.data.frame(as.matrix(x[ry, type == 2]), gf)
  X.SS <- lapply(XG, crossprod)
  yg <- split(as.vector(y[ry]), gf)
  n.g <- tabulate(gf)
  n.rc <- ncol(XG[[1]])

  bees <- matrix(0, nrow = n.class, ncol = n.rc)
  ss <- vector(mode = "numeric", length = n.class)
  mu <- rep.int(0, n.rc)
  inv.psi <- diag(1, n.rc, n.rc)
  inv.sigma2 <- rep.int(1, n.class)
  sigma2.0 <- 1
  theta <- 1

  ## Execute Gibbs sampler
  for (iter in seq_len(n.iter)) {
    ## Draw bees
    for (class in seq_len(n.class)) {
      vv <- symridge(inv.sigma2[class] * X.SS[[class]] + inv.psi, ...)
      bees.var <- chol2inv(chol(vv))
      bees[class, ] <- drop(bees.var %*% (crossprod(inv.sigma2[class] * XG[[class]], yg[[class]]) + inv.psi %*% mu)) +
        drop(rnorm(n = n.rc) %*% chol(symridge(bees.var, ...)))
      ss[class] <- crossprod(yg[[class]] - XG[[class]] %*% bees[class, ])
    }

    ## Draw mu
    mu <- colMeans(bees) + drop(rnorm(n = n.rc) %*%
      chol(chol2inv(chol(symridge(inv.psi, ...))) / n.class))

    ## Draw psi
    inv.psi <- rwishart(
      df = n.class - n.rc - 1,
      SqrtSigma = chol(chol2inv(chol(symridge(crossprod(t(t(bees) - mu)), ...))))
    )

    ## Draw sigma2
    inv.sigma2 <- rgamma(n.class, n.g / 2 + 1 / (2 * theta), scale = 2 * theta / (ss * theta + sigma2.0))

    ## Draw sigma2.0
    H <- 1 / mean(inv.sigma2) # Harmonic mean
    sigma2.0 <- rgamma(1, n.class / (2 * theta) + 1, scale = 2 * theta * H / n.class)

    ## Draw theta
    G <- exp(mean(log(1 / inv.sigma2))) # Geometric mean
    theta <- 1 / rgamma(1, n.class / 2 - 1, scale = 2 / (n.class * (sigma2.0 / H - log(sigma2.0) + log(G) - 1)))
  }

  ## Generate imputations
  imps <- rnorm(n = sum(wy), sd = sqrt(1 / inv.sigma2[gf.full[wy]])) + rowSums(as.matrix(x[wy, type == 2, drop = FALSE]) * bees[gf.full[wy], ])
  imps
}


rwishart <- function(df, p = nrow(SqrtSigma), SqrtSigma = diag(p)) {
  ## rwishart, written by Bill Venables
  Z <- matrix(0, p, p)
  diag(Z) <- sqrt(rchisq(p, df:(df - p + 1)))
  if (p > 1) {
    pseq <- seq_len(p - 1)
    Z[rep(p * pseq, pseq) + unlist(lapply(pseq, seq))] <- rnorm(p * (p - 1) / 2)
  }
  crossprod(Z %*% SqrtSigma)
}


force.chol <- function(x, warn = TRUE) {
  z <- 0

  repeat {
    lambda <- 0.1 * z
    XT <- x + diag(x = lambda, nrow = nrow(x))
    XT <- (XT + t(XT)) / 2
    s <- try(expr = chol(XT), silent = TRUE)
    if (class(s) != "try-error") {
      break
    }
    z <- z + 1
  }

  attr(s, "forced") <- (z > 0)
  if (warn && z > 0) {
    warning("Cholesky decomposition had to be forced", call. = FALSE)
  }

  s
}


symridge <- function(x, ridge = 0.0001, ...) {
  x <- (x + t(x)) / 2
  if (nrow(x) == 1L) {
    return(x)
  }
  x + diag(diag(x) * ridge)
}

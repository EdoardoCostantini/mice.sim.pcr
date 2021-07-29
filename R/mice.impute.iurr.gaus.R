#' Imputation by indirect use of regularised regression (IURR)
#'
#' Imputes univariate missing data using lasso 2-step linear regression
#'
#' @aliases mice.impute.iurr.gaus iurr.gaus
#' @inheritParams mice.impute.pmm
#' @return Vector with imputed data, same type as \code{y}, and of length
#' \code{sum(wy)}
#' @details
#' Uses lasso penalty to identify an active set, then samples imputation model
#' parameter values and uses them to define a posterior predictive distirbution
#' to sample imputations.
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
mice.impute.iurr.gaus <- function(y, ry, x, wy = NULL, ...) {
  # Internal function for lm loss function
  lmLoss <- function(theta, Y, X){
    # source: https://rpubs.com/YaRrr/MLTutorial
    k <- ncol(X)
    beta <- theta[1:k]
    sigma <- theta[k+1]

    # Check validity of sigma
    if(sigma < 0) {
      # the optimization procedure to stay away from invalid parameter values.
      dev <- 1e7
    } else {
      # calculate (log) likelihood of each data point
      ll <- stats::dnorm(Y, mean = X %*% beta, sd = sigma, log = TRUE)
      # summarize into deviance score
      dev <- -2 * sum(ll)
    }
    # Return
    return(dev)
  }

  # Body
  if (is.null(wy)) wy <- !ry
  xobs <- x[ry, , drop = FALSE]
  xmis <- x[wy, , drop = FALSE]
  yobs <- y[ry]

  # Train imputation model
  # used later in the estiamtion require this.
  cv_lasso <- glmnet::cv.glmnet(x = xobs, y = yobs,
                                family = "gaussian",
                                nfolds = 10, alpha = 1)

  # Extract Regularized Regression Coefs
  rr_coef <- as.matrix(coef(cv_lasso, s = "lambda.min"))[, 1]
  rr_coef_no0 <- names(rr_coef)[rr_coef != 0]
  rr_coef_noInt <- rr_coef_no0[-1]

  # Check if n-2 < p
  # -1 to estiamte sigma, -1 to esimate the intercept
  if((length(yobs)-2) < length(rr_coef_noInt)){
    # Drop the smallest coefficients that make the system defined
    coef_sort <- sort(rr_coef[names(rr_coef) %in% rr_coef_noInt])
    coef_drop <- names(coef_sort[-(1:(length(yobs)-2))])
    coef_drop_index <- c(1, which(rr_coef_no0 %in% coef_drop))
  } else {
    coef_drop_index <- 1 # just intercept
  }

  # Define Active Set
  AS <- rr_coef_no0[-coef_drop_index]
  dt_train <- data.frame(cbind(yobs, xobs[, AS]))

  # Imputations
  # Define starting values
  if(identical(rr_coef_no0, "(Intercept)")){
    lm_fit <- lm(yobs ~ 1)
    X_mle <- model.matrix(yobs ~ 1)
  } else {
    lm_fit <- lm(yobs ~ ., data = dt_train)
    X_mle  <- model.matrix(yobs ~ ., dt_train)
    b_est <- coef(lm_fit)[!is.na(coef(lm_fit))]
    X_mle  <- X_mle[, colnames(X_mle) %in% names(b_est)]
    # Fix NAs when coefficinet cannot be estiamted because variable
    # is near constant
  }
  start_values <- c(coef(lm_fit), stats::sigma(lm_fit))

  # MLE estiamtes by Optimize loss function
  MLE_fit <- stats::optim(start_values,
                   lmLoss,
                   method = "BFGS",
                   hessian = T,
                   Y = yobs, X = X_mle)
  theta <- MLE_fit$par
  OI <- solve(MLE_fit$hessian) # parameters cov matrix

  # Sample parameters for posterior predictive distribution
  pdraws_par <- MASS::mvrnorm(1, mu = theta, Sigma = OI)

  # Posterior Predictive Draws
  if(identical(rr_coef_no0, "(Intercept)")){
    y_imp <- rnorm(n = nrow(xmis),
                   mean = pdraws_par[1],
                   sd = pdraws_par[2])
  } else {
    xppd <- model.matrix( ~ xmis[, AS]) # X for posterior pred dist
    bppd <- pdraws_par[-length(pdraws_par)] # betas for posterior pred dist
    sigmappd <- tail(pdraws_par, 1) # sigma for posterior pred dist
    y_imp <- rnorm(n = nrow(xppd),
                   mean = xppd %*% bppd,
                   sd = sigmappd)
  }
  y_imp
}
% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mice.impute.logreg.R
\name{mice.pcr.sim.impute.logreg}
\alias{mice.pcr.sim.impute.logreg}
\title{Imputation by logistic regression}
\usage{
mice.pcr.sim.impute.logreg(y, ry, x, wy = NULL, ...)
}
\arguments{
\item{y}{Vector to be imputed}

\item{ry}{Logical vector of length \code{length(y)} indicating the
the subset \code{y[ry]} of elements in \code{y} to which the imputation
model is fitted. The \code{ry} generally distinguishes the observed
(\code{TRUE}) and missing values (\code{FALSE}) in \code{y}.}

\item{x}{Numeric design matrix with \code{length(y)} rows with predictors for
\code{y}. Matrix \code{x} may have no missing values.}

\item{wy}{Logical vector of length \code{length(y)}. A \code{TRUE} value
indicates locations in \code{y} for which imputations are created.}

\item{...}{Other named arguments.}
}
\value{
Vector with imputed data, same type as \code{y}, and of length
\code{sum(wy)}
}
\description{
Imputes univariate missing data using logistic regression.
}
\details{
Imputation for binary response variables by the Bayesian logistic regression
model (Rubin 1987, p. 169-170).  The
Bayesian method consists of the following steps:
\enumerate{
\item Fit a logit, and find (bhat, V(bhat))
\item Draw BETA from N(bhat, V(bhat))
\item Compute predicted scores for m.d., i.e. logit-1(X BETA)
\item Compare the score to a random (0,1) deviate, and impute.
}
The method relies on the
standard \code{glm.fit} function. Warnings from \code{glm.fit} are
suppressed. Perfect prediction is handled by the data augmentation
method.
}
\references{
Van Buuren, S., Groothuis-Oudshoorn, K. (2011). \code{mice.pcr.sim}:
Multivariate Imputation by Chained Equations in \code{R}. \emph{Journal of
Statistical Software}, \bold{45}(3), 1-67.
\url{https://www.jstatsoft.org/v45/i03/}

Brand, J.P.L. (1999). Development, Implementation and Evaluation of Multiple
Imputation Strategies for the Statistical Analysis of Incomplete Data Sets.
Ph.D. Thesis, TNO Prevention and Health/Erasmus University Rotterdam. ISBN
90-74479-08-1.

Venables, W.N. & Ripley, B.D. (1997). Modern applied statistics with S-Plus
(2nd ed). Springer, Berlin.

White, I., Daniel, R. and Royston, P (2010). Avoiding bias due to perfect
prediction in multiple imputation of incomplete categorical variables.
Computational Statistics and Data Analysis, 54:22672275.
}
\seealso{
\code{\link{mice.pcr.sim}}, \code{\link{glm}}, \code{\link{glm.fit}}

Other univariate imputation functions: 
\code{\link{mice.pcr.sim.impute.cart}()},
\code{\link{mice.pcr.sim.impute.durr.bern}()},
\code{\link{mice.pcr.sim.impute.durr.gaus}()},
\code{\link{mice.pcr.sim.impute.iurr.gaus}()},
\code{\link{mice.pcr.sim.impute.lda}()},
\code{\link{mice.pcr.sim.impute.logreg.boot}()},
\code{\link{mice.pcr.sim.impute.mean}()},
\code{\link{mice.pcr.sim.impute.midastouch}()},
\code{\link{mice.pcr.sim.impute.mnar.logreg}()},
\code{\link{mice.pcr.sim.impute.norm.boot}()},
\code{\link{mice.pcr.sim.impute.norm.nob}()},
\code{\link{mice.pcr.sim.impute.norm.predict}()},
\code{\link{mice.pcr.sim.impute.norm}()},
\code{\link{mice.pcr.sim.impute.pcr.boot}()},
\code{\link{mice.pcr.sim.impute.pcr.mixed}()},
\code{\link{mice.pcr.sim.impute.pcr.pmm}()},
\code{\link{mice.pcr.sim.impute.pmm}()},
\code{\link{mice.pcr.sim.impute.polr}()},
\code{\link{mice.pcr.sim.impute.polyreg}()},
\code{\link{mice.pcr.sim.impute.quadratic}()},
\code{\link{mice.pcr.sim.impute.rf}()},
\code{\link{mice.pcr.sim.impute.ri}()}
}
\author{
Stef van Buuren, Karin Groothuis-Oudshoorn
}
\concept{univariate imputation functions}
\keyword{datagen}

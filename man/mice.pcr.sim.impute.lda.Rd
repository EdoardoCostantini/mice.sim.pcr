% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mice.impute.lda.R
\name{mice.pcr.sim.impute.lda}
\alias{mice.pcr.sim.impute.lda}
\title{Imputation by linear discriminant analysis}
\usage{
mice.pcr.sim.impute.lda(y, ry, x, wy = NULL, ...)
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

\item{...}{Other named arguments. Not used.}
}
\value{
Vector with imputed data, of type factor, and of length
\code{sum(wy)}
}
\description{
Imputes univariate missing data using linear discriminant analysis
}
\details{
Imputation of categorical response variables by linear discriminant analysis.
This function uses the Venables/Ripley functions \code{lda()} and
\code{predict.lda()} to compute posterior probabilities for each incomplete
case, and draws the imputations from this posterior.

This function can be called from within the Gibbs sampler by specifying
\code{"lda"} in the \code{method} argument of \code{mice.pcr.sim()}. This method is usually
faster and uses fewer resources than calling the function, but the statistical
properties may not be as good (Brand, 1999).
\code{\link{mice.pcr.sim.impute.polyreg}}.
}
\section{Warning}{
 The function does not incorporate the variability of the
discriminant weight, so it is not 'proper' in the sense of Rubin. For small
samples and rare categories in the \code{y}, variability of the imputed data
could therefore be underestimated.

Added: SvB June 2009 Tried to include bootstrap, but disabled since
bootstrapping may easily lead to constant variables within groups.
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

Venables, W.N. & Ripley, B.D. (1997). Modern applied statistics with S-PLUS
(2nd ed). Springer, Berlin.
}
\seealso{
\code{\link{mice.pcr.sim}}, \code{link{mice.pcr.sim.impute.polyreg}},
\code{\link[MASS]{lda}}

Other univariate imputation functions: 
\code{\link{mice.pcr.sim.impute.cart}()},
\code{\link{mice.pcr.sim.impute.durr.bern}()},
\code{\link{mice.pcr.sim.impute.durr.gaus}()},
\code{\link{mice.pcr.sim.impute.iurr.gaus}()},
\code{\link{mice.pcr.sim.impute.logreg.boot}()},
\code{\link{mice.pcr.sim.impute.logreg}()},
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
Stef van Buuren, Karin Groothuis-Oudshoorn, 2000
}
\concept{univariate imputation functions}
\keyword{datagen}

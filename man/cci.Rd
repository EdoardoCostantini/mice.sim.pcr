% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cci.R
\name{cci}
\alias{cci}
\title{Complete case indicator}
\usage{
cci(x)
}
\arguments{
\item{x}{An \code{R} object. Currently supported are methods for the
following classes: \code{mids}.}
}
\value{
Logical vector indicating the complete cases.
}
\description{
The complete case indicator is useful for extracting the subset of complete cases. The function
\code{cci(x)} calls \code{complete.cases(x)}.
The companion function \code{ici()} selects the incomplete cases.
}
\examples{
cci(nhanes) # indicator for 13 complete cases
cci(mice.pcr.sim(nhanes, maxit = 0))
f <- cci(nhanes[, c("bmi", "hyp")]) # complete data for bmi and hyp
nhanes[f, ] # obtain all data from those with complete bmi and hyp
}
\seealso{
\code{\link{complete.cases}}, \code{\link{ici}}, \code{\link{cc}}
}
\author{
Stef van Buuren, 2017.
}
\keyword{univar}

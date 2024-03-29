% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nhanes.R
\docType{data}
\name{nhanes}
\alias{nhanes}
\title{NHANES example - all variables numerical}
\format{
A data frame with 25 observations on the following 4 variables.
\describe{
\item{age}{Age group (1=20-39, 2=40-59, 3=60+)}
\item{bmi}{Body mass index (kg/m**2)}
\item{hyp}{Hypertensive (1=no,2=yes)}
\item{chl}{Total serum cholesterol (mg/dL)} }
}
\source{
Schafer, J.L. (1997).  \emph{Analysis of Incomplete Multivariate
Data.} London: Chapman & Hall. Table 6.14.
}
\description{
A small data set with non-monotone missing values.
}
\details{
A small data set with all numerical variables. The data set \code{nhanes2} is
the same data set, but with \code{age} and \code{hyp} treated as factors.
}
\examples{
# create 5 imputed data sets
imp <- mice.pcr.sim(nhanes)

# print the first imputed data set
complete(imp)
}
\seealso{
\code{\link{nhanes2}}
}
\keyword{datasets}

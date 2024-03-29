% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formula.R
\name{make.formulas}
\alias{make.formulas}
\title{Creates a \code{formulas} argument}
\usage{
make.formulas(data, blocks = make.blocks(data), predictorMatrix = NULL)
}
\arguments{
\item{data}{A \code{data.frame} with the source data}

\item{blocks}{An optional specification for blocks of variables in
the rows. The default assigns each variable in its own block.}

\item{predictorMatrix}{A \code{predictorMatrix} specified by the user.}
}
\value{
A list of formula's.
}
\description{
This helper function creates a valid \code{formulas} object. The
\code{formulas} object is an argument to the \code{mice.pcr.sim} function.
It is a list of formula's that specifies the target variables and
the predictors by means of the standard \code{~} operator.
}
\examples{
f1 <- make.formulas(nhanes)
f1
f2 <- make.formulas(nhanes, blocks = make.blocks(nhanes, "collect"))
f2

# for editing, it may be easier to work with the character vector
c1 <- as.character(f1)
c1

# fold it back into a formula list
f3 <- name.formulas(lapply(c1, as.formula))
f3
}
\seealso{
\code{\link{make.blocks}}, \code{\link{make.predictorMatrix}}
}

#' Multiply imputed repeated analyses (\code{mira})
#'
#' The \code{mira} object is generated by the \code{with.mids()} function.
#' The \code{as.mira()}
#' function takes the results of repeated complete-data analysis stored as a
#' list, and turns it into a \code{mira} object that can be pooled.
#'
#' @section Slots:
#'  \describe{
#'  #'    \item{\code{.Data}:}{Object of class \code{"list"} containing the
#'    following slots:}
#'    \item{\code{call}:}{The call that created the object.}
#'    \item{\code{call1}:}{The call that created the \code{mids} object that was used
#' in \code{call}.}
#'    \item{\code{nmis}:}{An array containing the number of missing observations per
#' column.}
#'    \item{\code{analyses}:}{A list of \code{m} components containing the individual
#' fit objects from each of the \code{m} complete data analyses.}
#'    }
#'
#' @details
#' In versions prior to \code{mice.pcr.sim 3.0} pooling required only that
#' \code{coef()} and \code{vcov()} methods were available for fitted
#' objects. \emph{This feature is no longer supported}. The reason is that \code{vcov()}
#' methods are inconsistent across packages, leading to buggy behaviour
#' of the \code{pool()} function. Since \code{mice.pcr.sim 3.0+}, the \code{broom}
#' package takes care of filtering out the relevant parts of the
#' complete-data analysis. It may happen that you'll see the messages
#' like \code{No method for tidying an S3 object of class ...} or
#' \code{Error: No glance method for objects of class ...}. The royal
#' way to solve this problem is to write your own \code{glance()} and \code{tidy()}
#' methods and add these to \code{broom} according to the specifications
#' given in \url{https://broom.tidymodels.org}.
#'
#' #'The \code{mira} class of objects has methods for the
#' following generic functions: \code{print}, \code{summary}.
#'
#' Many of the functions of the \code{mice.pcr.sim} package do not use the
#' S4 class definitions, and instead rely on the S3 list equivalent
#' \code{oldClass(obj) <- "mira"}.
#'
#' @name mira-class
#' @rdname mira-class
#' @aliases mira-class mira
#' @author Stef van Buuren, Karin Groothuis-Oudshoorn, 2000
#' @seealso \code{\link{with.mids}}, \code{\link[=mids-class]{mids}}, \code{\link{mipo}}
#' @references van Buuren S and Groothuis-Oudshoorn K (2011). \code{mice.pcr.sim}:
#' Multivariate Imputation by Chained Equations in \code{R}. \emph{Journal of
#' Statistical Software}, \bold{45}(3), 1-67.
#' \url{https://www.jstatsoft.org/v45/i03/}
#' @keywords classes
#' @export
setClass("mira",
  representation(
    call = "call",
    call1 = "call",
    nmis = "integer",
    analyses = "list"
  ),
  contains = "list"
)

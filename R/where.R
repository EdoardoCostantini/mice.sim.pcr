#' Creates a \code{where} argument
#'
#' This helper function creates a valid \code{where} matrix. The
#' \code{where} matrix is an argument to the \code{mice.pcr.sim} function.
#' It has the same size as \code{data} and specifies which values
#' are to be imputed (\code{TRUE}) or nor (\code{FALSE}).
#' @param data A \code{data.frame} with the source data
#' @param keyword An optional keyword, one of \code{"missing"} (missing
#' values are imputed), \code{"observed"} (observed values are imputed),
#' \code{"all"} and \code{"none"}. The default
#' is \code{keyword = "missing"}
#' @return A matrix with logical
#' @seealso \code{\link{make.blocks}}, \code{\link{make.predictorMatrix}}
#' @examples
#' head(make.where(nhanes), 3)
#' @export
make.where <- function(data,
                       keyword = c("missing", "all", "none", "observed")) {
  keyword <- match.arg(keyword)

  data <- check.dataform(data)
  where <- switch(keyword,
    missing = is.na(data),
    all = matrix(TRUE, nrow = nrow(data), ncol = ncol(data)),
    none = matrix(FALSE, nrow = nrow(data), ncol = ncol(data)),
    observed = !is.na(data)
  )

  dimnames(where) <- dimnames(data)
  where
}


check.where <- function(where, data, blocks) {
  if (is.null(where)) {
    where <- make.where(data, keyword = "missing")
  }

  if (!(is.matrix(where) || is.data.frame(where))) {
    if (is.character(where)) {
      return(make.where(data, keyword = where))
    } else {
      stop("Argument `where` not a matrix or data frame", call. = FALSE)
    }
  }
  if (!all(dim(data) == dim(where))) {
    stop("Arguments `data` and `where` not of same size", call. = FALSE)
  }

  where <- as.logical(as.matrix(where))
  if (anyNA(where)) {
    stop("Argument `where` contains missing values", call. = FALSE)
  }

  where <- matrix(where, nrow = nrow(data), ncol = ncol(data))
  dimnames(where) <- dimnames(data)
  where[, !colnames(where) %in% unlist(blocks)] <- FALSE
  where
}

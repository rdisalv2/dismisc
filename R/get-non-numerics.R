#' Gets all non-numerics of a vector
#'
#' returns a subvector containing all entries that will go to NA when you as.numeric; useful for tabbing
#'
#' @param x a character vector
#' @return x[is.na(as.numeric(x))]
#'
#' @note It might be just as easy to do x %>% .[is.na(as.numeric(x))].
#'
#' @export
get_non_numerics <- function(x) {
  # old version: return(x[is.na(as.numeric(x) & !is.na(x))])
  return(x[is.na(as.numeric(x))])
}

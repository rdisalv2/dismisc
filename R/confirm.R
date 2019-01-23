


#' Confirm if the rows of data are uniquely identified by cols
#'
#' @param data data.frame to check
#' @param cols char vect of identifier cols
#'
#' @return
#' @export
confirm_ids <- function(data, cols) {
  ndata <- nrow(data)
  nids <- nrow(dplyr::distinct(as_data_frame(data[,cols])))
  print(ndata==nids)
  stopifnot(ndata==nids)
}

# confirm_ids(counties,c('ImportParcelID'))

#' Confirm if two datasets will join properly (before calling some dplyr join function)
#'
#' @param x Same as left_join
#' @param y Same as left_join
#' @param by Same as left_join
#' @param how either 1:1, m:1, or 1:m (as in stata)
#'
#' @return
#' @export
confirm_join <- function(x,y, by = NULL, how = '1:1') {
  if(is.null(by)) {
    by <- intersect(names(x),names(y))
    message(paste0('by = ', paste0(by,collapse=', ')))
  }
  if(how=='1:1') {
    stopifnot((nrow(distinct_(x, .dots = by)) == nrow(x)))
    stopifnot((nrow(distinct_(y, .dots = by)) == nrow(y)))
  }
  if(how=='m:1') {
    stopifnot((nrow(distinct_(y, .dots = by)) == nrow(y)))
  }
  if(how=='1:m') {
    stopifnot((nrow(distinct_(x, .dots = by)) == nrow(x)))
  }
  message(paste0(how, ' join confirmed'))
}

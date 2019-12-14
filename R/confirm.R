


#' Confirm if the rows of data are uniquely identified by cols
#'
#' @param data data.frame to check
#' @param cols char vect of identifier cols
#'
#' @return
#' @export
confirm_ids <- function(data, ..., .dots = NULL, .raise_error=TRUE) {
  if(!is.null(.dots)) {
    dots <- .dots
  } else {
    dots <- substitute(list(...))[-1]
    dots <- sapply(dots,deparse)
  }
  notids <- (anyDuplicated(data[,dots])!=0)
  if(.raise_error) {
    if(notids) {
      stop(paste0(paste0(dots,collapse=', '),' do not uniquely identify rows'))
    }
  } else{
    return(!notids)
  }
}

# confirm_ids(mtcars, mpg, cyl)

# # confirm_ids(counties,c('ImportParcelID'))
# confirm_ids(mtcars,c('mpg'))
# microbenchmark::microbenchmark({
#   confirm_ids(mtcars,c('mpg'),raise_error=FALSE)
# })
# # 757.9642
# # 8.75532 with anyDuplicated. yep this is way better.
# df <- data.frame(i = c(1,1,2,2,3,3),t=c(1,2,1,2,1,2)) # typical panel dataset
# confirm_ids(df,.dots=c('i'))
# confirm_ids(df,.dots = c('i','t'))
# microbenchmark::microbenchmark({
#   confirm_ids(df,.dots=c('i','t'),raise_error=FALSE)
# })
#
# microbenchmark::microbenchmark({
#   confirm_ids(df,i,t,.raise_error=FALSE)
# })

#' Confirm if two datasets will join properly (before calling some dplyr join function)
#'
#' @param x Same as left_join
#' @param y Same as left_join
#' @param by Same as left_join
#' @param how either 1:1, m:1, or 1:m (as in stata)
#'
#' @return
#' @export
confirm_join <- function(x,y, by = NULL, by.x = NULL, by.y = NULL, how = '1:1') {
  if(is.null(by.y) & is.null(by.x) & !is.null(by)) {
    by.x <- by
    by.y <- by
  } else if(!is.null(by.y) | !is.null(by.x)) {
    stop("Both of by.x by.y should be NULL or a character vector")
  } else if(is.null(by) & is.null(by.x) & is.null(by.y)) {
    by <- intersect(names(x),names(y))
    message(paste0('by = ', paste0(by,collapse=', ')))
    by.x <- by
    by.y <- by
  }
  if(how=='1:1') {
    if(!confirm_ids(x,.dots=by.x,.raise_error = FALSE)) {
      stop('LHS rows not identified by "by"')
    }
    if(!confirm_ids(y,.dots=by.y,.raise_error = FALSE)) {
      stop('RHS rows not identified by "by"')
    }

  }
  if(how=='m:1') {
    if(!confirm_ids(y,.dots=by.y,.raise_error=FALSE)) {
      stop('RHS rows not identified by "by"')
    }
  }
  if(how=='1:m') {
    if(!confirm_ids(x,.dots=by.x,.raise_error=FALSE)) {
      stop('LHS rows not identified by "by"')
    }
  }
  message(paste0(how, ' join confirmed'))
}

# df <- data.frame(i = c(1,1,2,2,3,3),t=c(1,2,1,2,1,2)) # typical panel dataset
# df2 <- data.frame(i = c(1,2,3),x = c(1,3,4)) # cross-sectional dataset to join on
# confirm_join(df,df2,by = c('i'), how= 'm:1')
# microbenchmark::microbenchmark({
#   confirm_join(df,df2,by = c('i'), how= 'm:1')
#   })
# confirm_join(df,df2,by = c('i'), how= 'm:1')



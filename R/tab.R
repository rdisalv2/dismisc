
#' wrapper for statar::tab, to handle vector input
#'
#' @param x Either a vector or a data.frame
#' @param ... if x is a data.frame, then a list of variables to tab
#'
#' @return See ?statar::tab
#' @export
tab <- function(x, ...) {
  xname <- deparse(substitute(x))
  xsym <- as.name(xname)
  if(is.vector(x)) {
    x <- data.frame(x)
    names(x) <- xname
    statar::tab(x,!!xsym)
  } else if(is.data.frame(x)) {
    statar::tab(x,...)
  }
}

# x <- c(1,2,3,4,5,2,2,3,4,2,3,1,2,3)
# tab(x)
# tab(data.frame(x),x)
# y <- x
# tab(y)
# tab(data.frame(y),y)

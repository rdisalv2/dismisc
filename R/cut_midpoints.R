

#' Cut number, return midpoints
#' 
#' Like ggplot2::cut_number, except returns the midpoints of the intervals rather than intervals (factors).
#'
#' @param x numeric vector
#' @param n number of intervals to create
#' @param ... Arguments passed on to base::cut.default 
#'
#' @return
#' @export
#'
#' @examples
cut_midpoints <- function(x, n, ...) {
  library(stringr)
  
  temp <- ggplot2::cut_number(x,n,...)
  
  temp <- as.character(temp)
  
  midpoints <- (as.numeric(str_sub(str_extract(temp,'(\\(|\\[).*,'),2,-2)) + as.numeric(str_sub(str_extract(temp,',.*(\\)|\\])'),2,-2)))/2
  
  return(midpoints)
  
}
# cut_midpoints(c(1,2,3,2,3,2,3,2,3,2,2,3,2,2,1),2)

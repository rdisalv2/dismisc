
#' Capitalize a string
#'
#' @param x String to capitalize
#'
#' @return Capitalized string
#' @export
simpleCap <- function(x) {

  xUpper <- strsplit(x, "( |-)")[[1]]

  s <- tolower(x)
  s <- strsplit(s, "( |-)")[[1]]

  for(ii in 1:length(xUpper)) {
    stemp <- paste(toupper(substring(s[ii], 1,1)), substring(s[ii], 2),
                   sep="", collapse=" ")
    stringr::str_replace_all(x,pattern=xUpper[ii],replacement=stemp) -> x
  }
  x
}


#' Parse censored data in the form used by EdFacts.
#'
#' You have numeric data stored like 75-80, GE75, LE25, LT50 etc. You want to replace with the midpoints (a common approach). This function does this parsing.
#'
#'
#' In particular the censored data looks like this:
#'
#' * numbers are like 75-80, with a dash in the middle meaning that it is somewhere in that range; or
#'
#' * numbers are like GE75, meaning >=75
#'
#' * numbers are like LE25, meaning <=25
#'
#' * numbers are like LT50, meaning <50 (effectively the same as <=50 and treated as such here)
#'
#' Given a character vector, this function returns a numeric vector that:
#'
#' * returns the midpoint of things that look like 75-80 e.g.;
#'
#' * returns (maxnum+75)/2 for GE75 e.g.;
#'
#' * returns (minnum+25)/2 for LE25 e.g.
#'
#' @note The name of the function will hopefully prevent conflicts with other packages but the method is probably more general than edfacts data.
#'
#' @param vect character vector to parse
#' @param maxnum maximum for purposes of GE and GT
#' @param minnum minimum for purposes of LE and LT
#'
#' @return numeric vector of parsed data (with NA where the parse failed)
#'
#' @export
parse_censored_data_edfacts <- function(vect,maxnum=100,minnum=0) {

  # split by dash
  vect %>% stringr::str_split_fixed(pattern='-',n=2) -> splitvect
  # convert parts of the split to numeric
  vect1 <- splitvect[,1] %>% as.numeric
  vect2 <- splitvect[,2] %>% as.numeric

  # try to convert to numeric directly
  toret <- vect %>% as.numeric
  # if that fails, try the split by dash
  toret <- ifelse(is.na(toret),(vect1+vect2)/2,toret)
  # if that fails, try the GE|GT case
  toret <- ifelse(stringr::str_detect(vect,'(GE|GT)'),
                  (as.numeric(stringr::str_extract(vect,"[0-9]+"))+maxnum)/2,
                  toret)
  # if that fails, try the LE|LT case
  toret <- ifelse(stringr::str_detect(vect,'(LE|LT)'),
                  (as.numeric(stringr::str_extract(vect,"[0-9]+"))+minnum)/2,
                  toret)

  # return the product
  return(toret)

}

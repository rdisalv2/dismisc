

#' TexHelp round/signif chars
#'
#' t_td forces there to be d digits after the decimal for the numeric input x, without messing with the "integer part" of x; t_sd messes with the integer part (i.e. uses significant digits). Both are vectorized over x.
#'
#' @param x numeric to clean; if not numeric, will be coerced
#' @param d number of trailing digits (for t_td) or significant digits (for t_sd)
#' @param commas whether to insert commas in the number (the default)
#' @param except do not modify these positions of the vector
#'
#' @details
#' t_td ("texhelp trailing digits") returns a character vector version of x, rounded or expanded with trailing digits so that there are exactly d digits after the decimal point. That is, rounding is done or 0s are added to the end as needed.
#'
#' t_sd ("texhelp significant digits") returns a character vector version of x so that there are exactly d significant digits shown. Trailing zeroes are added as needed, to make the point that there are actually d significant digits.
#'
#' (In most cases you will want to use t_td in order to force a list of numbers to have the same number of trailing digits -- this looks better.)
#'
#' In both functions, commas are added where necessary; turn off with commas=FALSE.
#'
#' The except parameter is included to make it painless to deal with the common case of an identifying column for which you do not want trailing digits.
#'
#' @return a cleaned charater vector version of the numeric
#' @export
#'
#' @examples
#' t_td(c(123.2,1.231, 1.8764, 1543.999,1532.987),d=2)
#' t_sd(c(2342.232,232.213,323.23,0.99999),d=2)
t_td <- function(x,d=0,commas=TRUE,except=c()) {
  library(stringr)

  x_old <- x
  x[except] <- 0
  x <- as.numeric(x)

  # d <- d + 1
  # R2 <- function(x) {
  #   round(x,digits=d)
  # }
  x_rounded <- round(x,digits=d)

  # the numbers before & after decimal points BEFORE correction are:
  # bf.dec.points <- str_length(str_replace_all(str_split_fixed(R2(x),"[.]",n=2)[1],pattern='-',replacement=''))
  # af.dec.points <- str_length(str_split_fixed(x_rounded,"[.]",n=2)[2])

  # number to add after decimal point
  # traildigits <- d - af.dec.points - 1
  # if(traildigits<0) traildigits = 0
  toret <- formatC(x_rounded,digits = d, format = 'f',big.mark=ifelse(commas,',',''))
  toret[except] <- as.character(x_old)[except]
  return(toret)
}

#' @export
#' @rdname t_td
t_sd <- function(x,d=1,commas=TRUE,except=c()) {
  library(stringr)

  x_old <- x
  x[except] <- 0
  x <- as.numeric(x)

  R2 <- function(x) {
    signif(x,digits=d)
  }

  # the numbers before & after decimal points BEFORE correction are:
  bf.dec.points <- stringr::str_length(str_replace_all(str_split_fixed(R2(x),"[.]",n=2)[1],pattern='-',replacement=''))
  af.dec.points <- stringr::str_length(str_split_fixed(R2(x),"[.]",n=2)[2])

  # number to show after decimal point
  traildigits <- d - bf.dec.points
  if(traildigits<0) traildigits = 0
  toret <- formatC(R2(x),digits = traildigits, format = 'f',big.mark=ifelse(commas,',',''))
  toret[except] <- as.character(x_old)[except]
  return(toret)
}


#' TexHelp functions to clean up regression tables
#'
#' t_pstar returns latex encoded starrage, given p-value; t_parw wraps the input with parentheses ().
#'
#' @param x numeric vector
#'
#' @details
#' t_pstar uses "economists" p-values: 0.10 gives one star, 0.05 gives 2 (and the right to publish), 0.01 gives 3.
#'
#' @return a "cleaned up" character version of x
#' @export
#'
#' @examples
#' t_pstar(c(0.03,0.34,0.06))
#' # combine with t_td for special effects
#' t_parw(t_td(c(1.21,3.23,3.2232),d=2))
t_pstar <- function(x) {
  p <- x
  starage <- dplyr::case_when(p<=0.01 ~ "$^{***}$",
                       p<=0.05 ~ "$^{**}$",
                       p<=0.10 ~ "$^{*}$",
                       TRUE ~ "")
  return(starage)
}

#' @export
#' @rdname t_pstar
t_parw <- function(x) {
    return(paste0('(',x,')'))
}



# TO DO:
# return starrage, given t-stat
# CAUTION: this by default will use degrees of freedom of infinity
# t_tstar <- function(x) {
#   starage <- case_when(p<=0.01 ~ "$^{***}$",
#                        p<=0.05 ~ "$^{**}$",
#                        p<=0.10 ~ "$^{*}$",
#                        TRUE ~ "")
# }



#' TexHelp ThreePartTable
#'
#' A (package R.rsp based) implementation of a ThreePartTable. ThreePartTable is a latex package that gives a table with a caption, body, and footer.
#'
#' @param topCaption The caption at the top of the table
#' @param label The latex label of the table (for cross references)
#' @param innerContents The inner contents of the table (usually "rout")
#' @param notes Notes to go at the bottom of the ThreePartTable
#' @param columnAlign Column alignment - like lcccc
#'
#' @details
#' The source code for this "R.rsp template" can be copied and pasted to make new functions to produce latex tables, depending on journal requirements.
#' (If the parameters remain essentially the same, transitioning from one latex table format to another should be relatively painless.)
#'
#' @return A character with the latex code for the three part table.
#' @export
TexHelp_threePartTable <- function(topCaption, label, innerContents, notes, columnAlign) {
  # curwd <- getwd()
  # setwdrt('paper/rsp-templates')

  threeparttablestring <- "
  \\begin{table}[htbp]
  \\centering
  \\begin{threeparttable}
  \\caption{<%=topCaption%>}
  \\label{<%=label%>}
  \\begin{tabular}{<%=columnAlign%>}
  \\toprule
  <%=innerContents%>
  \\bottomrule
  \\end{tabular}
  \\begin{tablenotes}
  \\small
  \\item <%=notes%>
  \\end{tablenotes}
  \\end{threeparttable}
  \\end{table}
  "
  R.rsp::rstring(threeparttablestring) -> res
  # setwd(curwd)
  return(res)
}




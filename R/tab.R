
#' like tab from statar, but ONLY works for vectors
#'
#' From https://github.com/matthieugomez/statar/ with significant modifications
#'
#' @param x A vector
#' @param sf shorthand for sort_freq
#' @param sv shorthand for sort_values
#' @param ss shorthand for suppress_small
#' @param sort_freq sort by frequency large to small.
#' @param sort_values sort by values large to small. overrides sort_freq.
#' @param suppress_small suppresses beyond this many levels for printing. only applies if sort_freq=TRUE. default 10. set to FALSE or Inf to not suppress.
#'
#' @return a data.frame with the tabulation
#' @export
tab <- function(x, sf = TRUE, sv = FALSE, ss = 10, sort_freq = sf, sort_values = sv, suppress_small = ss) {
  require(dplyr)

  if(sort_values) { # overrides sort_freq
    sort_freq <- FALSE
  }

  # for testing only
  # x <- sample(1:3,1000,replace=TRUE)
  # x <- c(1,2,3,4,5,2,2,3,4,2,3,1,2,3)
  # x <- sample(1:1000,1000, replace=TRUE)
  x <- dplyr::tibble(Level=x)
  thetable <- x %>% group_by(Level) %>% summarize(
    Freq. = n()
  ) %>% ungroup %>% mutate(
    Percent = (Freq./sum(Freq.))*100
  )

  if(sort_values) {
    thetable <- thetable %>% arrange(Level)
  } else if(sort_freq) {
    thetable <- thetable %>% arrange(Freq.)
  }

  thetable <- thetable %>% ungroup %>% mutate(
    Cum. = cumsum(Percent)
  )

  if(sort_freq) { # only suppress small if sort_values
    if(suppress_small!=FALSE & suppress_small!=0 & is.finite(suppress_small)) {
      didsuppress <- nrow(thetable)-suppress_small
      thetabletoprint <- thetable %>% slice(max(1,(nrow(thetable) - suppress_small + 1)):nrow(thetable))
      thetabletoprint <- thetabletoprint %>% mutate(
        Freq. = dismisc::t_td(Freq.,0),
        Percent = dismisc::t_td(Percent,2),
        Cum. = dismisc::t_td(Cum.,2)
      )
    }

    if(didsuppress>1) {
      suppressedrows <- thetable %>% slice(-(max(1,(nrow(thetable)-suppress_small + 1)):nrow(thetable)))
      stopifnot(nrow(suppressedrows)==didsuppress)
      suppressedpct <- suppressedrows$Percent %>% sum()
      suppressedfreq <- suppressedrows$Freq. %>% sum()
      thetabletoprint <- rbind(c(paste0('',(didsuppress), ' more levels'), suppressedfreq, suppressedpct,suppressedpct),thetabletoprint)
    }
  } else {
    thetabletoprint <- thetable
    thetabletoprint <- thetabletoprint %>% mutate(
      Freq. = dismisc::t_td(Freq.,0),
      Percent = dismisc::t_td(Percent,2),
      Cum. = dismisc::t_td(Cum.,2)
    )
  }

  print.data.frame(thetabletoprint)
  return(invisible(thetable))

}



#' like -su- in stata, but ONLY for vectors
#'
#' @param x a numeric vector
#'
#' @return nothing (prints summary output)
#' @export
suup <- function(x) {
  cat(sprintf('Obs %s   Missing %s   Mean %s   Median %s   StdDev %s \n',t_td(length(x),0), t_td(sum(is.na(x)),0), round(mean(x),3), round(median(x),3), round(sd(x),3)))
  cat('\n')
  print(quantile(x,c(0,0.01,0.05,0.10,0.25,0.50,0.75,0.90,0.95,0.99,1)))
}



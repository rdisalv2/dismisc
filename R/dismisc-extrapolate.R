

#' Extrapolate and interpolate values
#'
#' Uses a spline to extrapolate (and interpolate) values.
#'
#' Use in a dplyr chain something like this to interpolate within city:
#'
#' df %<>% group_by(city) %>% mutate_at(total_population,
#'
#'  funs(population_interpolated = dismisc_extrapolate(x=year,y=.)))
#'
#' If there are no non-missing y values, a vector of NAs is returned.
#'
#' @param x the independent variable; something like a time value
#' @param y the dependent variable; something like a population value
#' @param xout values to interpolate/extrapolate on, defaults to x
#' @param method can be "lm" or any method in stats::spline()
#'
#' @return the values of the extrapolated function y(x) on domain xout
#' @export
dismisc_extrapolate <- function(x,y,xout=x,method="natural") {

  stopifnot(length(x)==length(y))

  if(sum(!is.na(y))==0) {
    rep(NA,length(x))
  } else {
    if(method=="lm") {
      # do a linear interpolation/extrapolation

      # run an lm
      lm(y ~ x) -> lmmodel
      # predict y given x
      predict(lmmodel,data.frame(x=xout)) -> predictions

      # return the predictions
      return(predictions)

    } else {

      return(stats::spline(method=method,x=x,y=y,xout=xout)$y)
    }
  }

  # to be continued:
  # else if(method="connect.the.dots"){
  #   # each yout is a weighted average of the two nearest
  #   # points in xout
  #   x <- c(1,2,3,4,5)
  #   y <- c(3,NA,4,NA,NA)
  #
  #   yout <-
  #
  #   # now apply splines with method="natural" to extrapolate
  #   return(stats::spline(method="natural",x=x,y=y,xout=xout)$y)
  # }

}

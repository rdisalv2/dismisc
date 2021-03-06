% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/texhelp.R
\name{t_td}
\alias{t_td}
\alias{t_sd}
\title{TexHelp round/signif chars}
\usage{
t_td(x, d = 0, commas = TRUE, except = c())

t_sd(x, d = 1, commas = TRUE, except = c())
}
\arguments{
\item{x}{numeric to clean; if not numeric, will be coerced}

\item{d}{number of trailing digits (for t_td) or significant digits (for t_sd)}

\item{commas}{whether to insert commas in the number (the default)}

\item{except}{do not modify these positions of the vector}
}
\value{
a cleaned charater vector version of the numeric
}
\description{
t_td forces there to be d digits after the decimal for the numeric input x, without messing with the "integer part" of x; t_sd messes with the integer part (i.e. uses significant digits). Both are vectorized over x.
}
\details{
t_td ("texhelp trailing digits") returns a character vector version of x, rounded or expanded with trailing digits so that there are exactly d digits after the decimal point. That is, rounding is done or 0s are added to the end as needed.

t_sd ("texhelp significant digits") returns a character vector version of x so that there are exactly d significant digits shown. Trailing zeroes are added as needed, to make the point that there are actually d significant digits.

(In most cases you will want to use t_td in order to force a list of numbers to have the same number of trailing digits -- this looks better.)

In both functions, commas are added where necessary; turn off with commas=FALSE.

The except parameter is included to make it painless to deal with the common case of an identifying column for which you do not want trailing digits.
}
\examples{
t_td(c(123.2,1.231, 1.8764, 1543.999,1532.987),d=2)
t_sd(c(2342.232,232.213,323.23,0.99999),d=2)
}

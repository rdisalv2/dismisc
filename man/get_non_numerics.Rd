% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-non-numerics.R
\name{get_non_numerics}
\alias{get_non_numerics}
\title{Gets all non-numerics of a vector}
\usage{
get_non_numerics(x)
}
\arguments{
\item{x}{a character vector}
}
\value{
x[is.na(as.numeric(x))]
}
\description{
returns a subvector containing all entries that will go to NA when you as.numeric; useful for tabbing
}
\note{
It might be just as easy to do x %>% .[is.na(as.numeric(x))].
}

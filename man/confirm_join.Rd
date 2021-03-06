% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/confirm.R
\name{confirm_join}
\alias{confirm_join}
\title{Confirm if two datasets will join properly (before calling some dplyr join function)}
\usage{
confirm_join(x, y, by = NULL, by.x = NULL, by.y = NULL,
  how = "1:1")
}
\arguments{
\item{x}{Same as left_join}

\item{y}{Same as left_join}

\item{by}{Same as left_join}

\item{how}{either 1:1, m:1, or 1:m (as in stata)}
}
\description{
Confirm if two datasets will join properly (before calling some dplyr join function)
}

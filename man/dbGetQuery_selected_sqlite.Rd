% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/source-selected-source.R
\name{dbGetQuery_selected_sqlite}
\alias{dbGetQuery_selected_sqlite}
\title{Get query SQLite}
\usage{
dbGetQuery_selected_sqlite()
}
\description{
Call this function as an rstudio addin to push to a con with dbGetQuery
}
\details{
This is useful to e.g. displaying tables.

note that you cannot use double quotes:
http://stackoverflow.com/questions/1992314/what-is-the-difference-between-single-and-double-quotes-in-sql
}


#' Read in an mdb file.
#'
#' A shortened, simplified version of Hmisc::mdb.get
#'
#' Still uses mdbtools internally (so that needs to be installed). On Ubuntu, use sudo apt get install mdbtools.
#'
#' The process is to use mdbtools to convert the mdb table into a csv file, then use readr::read_csv to read the csv file in quickly.
#'
#' @param file mdb file to read. You may need to surround the name in quotes, like '"file name.mdb"'.
#' @param tables either a list or vector of table names; tables = TRUE to import a list of tables; or the default which means import all tables
#' @param mdbexportArgs arguments to pass to mdb-export. See details for some examples, and man mdb-export for a comprehensive discussion of all possible terminal arguments.
#' @param ... arguments passed to readr::read_csv.
#'
#' @details You will commonly want to use mdbexportArgs = '-D\%m/\%d/\%Y' to get the dates right. m means month, d means day, and Y means 4-digit year (note that y would mean 2 digit year). Without explicitly stating this, mdb-export will commonly export as m/d/y format instead, which makes it impossible to tell e.g. 1910 from 2010.
#'
#' you may also be interested in the common idiom, col_types = cols(.default = col_character()), which tells read_csv to read in all columns as characters. This is guaranteed to avoid parsing failures at the read_csv step.
#'
#' @return if only 1 table is read, a tibble. Otherwise, a list of tibbles containing all the tables read in.
#'
#' @export

mdb_get <- function (file, tables = NULL, mdbexportArgs = "", ...)
{

  # return tables if tables = TRUE
  if (tables==TRUE) {
    tables <- system(paste("mdb-tables -1", file), intern = TRUE)
    return(tables)
  }

  # otherwise, convert the mdb tables given using mdbexportArgs and pipe into a tempfile
  # this code is copied from Hmisc::mdb.get. However all the transformation of table names has been commented-out.
  f <- tempfile()
  tables <- unlist(tables)
  D <- vector("list", length(tables))
  names(D) <- tables

  for (tab in tables) {
    system(paste("mdb-export", mdbexportArgs, file, shQuote(tab),
                 ">", f))
    d <- readr::read_csv(f,...)
    if (length(tables) == 1)
      return(d)
    else D[[tab]] <- d
  }
  D
}

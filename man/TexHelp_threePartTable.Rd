% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/texhelp.R
\name{TexHelp_threePartTable}
\alias{TexHelp_threePartTable}
\title{TexHelp ThreePartTable}
\usage{
TexHelp_threePartTable(topCaption, label, innerContents, notes,
  columnAlign)
}
\arguments{
\item{topCaption}{The caption at the top of the table}

\item{label}{The latex label of the table (for cross references)}

\item{innerContents}{The inner contents of the table (usually "rout")}

\item{notes}{Notes to go at the bottom of the ThreePartTable}

\item{columnAlign}{Column alignment - like lcccc}
}
\value{
A character with the latex code for the three part table.
}
\description{
A (package R.rsp based) implementation of a ThreePartTable. ThreePartTable is a latex package that gives a table with a caption, body, and footer.
}
\details{
The source code for this "R.rsp template" can be copied and pasted to make new functions to produce latex tables, depending on journal requirements.
(If the parameters remain essentially the same, transitioning from one latex table format to another should be relatively painless.)
}

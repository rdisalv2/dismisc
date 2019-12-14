#' Remove all labels from a df
#'
#' e.g. after using a function in Hmisc that tacks on labels, or
#' haven::read_dta()
#'
#' @param df df to remove labels from
#'
#' @return df with labels removed
#' @export
clear_all_df_labels <- function(df) {
  for(cc in names(df)) {
    attr(df[[cc]],"label") <- NULL
  }
  return(df)
}

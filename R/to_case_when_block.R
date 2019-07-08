

#' Build case_when block for a mutate()
#'
#' @param uniqvals unique values of varname 
#' @param varname variable name for the LHS of the case_when block
#'
#' @return prints R code to the console that can be copy and pasted
#' @export
to_case_when_block <- function(uniqvals,varname) {
  
  # to_case_when_block(c('x','y','z'),'X')
  cat(paste0(
    'case_when(\n',paste0(paste0('  ',varname , " == '",uniqvals, "' ~ ''"), collapse = ',\n'),'\n)'))
  
}


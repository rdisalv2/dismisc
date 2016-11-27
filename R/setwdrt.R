

#' Set working directory, starting from a custom root directory
#'
#' Use setrt(dir, name = "") to set a custom root; use setwdrt(dir, name = "") to, roughly-speaking, setwd(paste0(root + name, dir)).
#'
#' Best way to use these functions is:
#'
#' \itemize{
#'   \item{in your init.R file that you run when you start working on a project}
#'     \itemize{
#'       \item{Use setrt(dir) to specify the root folder of your data project as dir}
#'       \item{Use setrt(dir, name ="someDependency") to specify the root folder of some dependency (e.g. the data from another project)}
#'     }
#'   \item{in your scripts, when you need to get to a subdirectory}
#'    \itemize{
#'      \item{Use setwdrt(dir) to go to that subdirectory; e.g. setwdrt('data') to go to root/data},
#'      \item{Use setwdrt(dir, name = "someDependency") to go to the subdir of that dependency}
#'    }
#' }
#'
#' An error is thrown if a particular custom root has not be defined but is called by setwdrt().
#'
#' @note Internally, these functions use a series of options that look like paste0(name,"dismisc_root").
#' Therefore, these custom roots survive remove(list=ls()) and other modifications to the global environment
#' (in the same way that attached libraries do), so it is reasonable to put them in init.R and run them once
#' when you start working on the project.
#'
#' If in calling setrt() no forward slash '/' is given at the end of dir, a forward slash '/' is appended.
#'
#' @param dir directory
#' @param name name of custom root; defaults to what you should consider the current project root
#'
#' @export
setrt <- function(dir = "~/",name="") {
  last.char <- stringr::str_split("hello",pattern="")[[1]] %>% .[length(.)]
  if(last.char!="/") dir <- paste0(dir,'/')
  options(setNames(object = list(dir),nm = paste0(name,'dismisc_root')))
}

#' @export
#' @rdname setrt
setwdrt <- function(dir = "", name = "") {
  if(is.null(getOption(paste0(name,"dismisc_root"),default=NULL))) {
    stop(paste0('Custom root is not defined.'))
  } else {
    setwd(paste0(getOption(paste0(name,"dismisc_root"),default=NULL),dir))
  }
}

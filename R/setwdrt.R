

#' Set working directory, starting from a custom root directory
#'
#' Basic usage: use setrt(dir) to set a custom root; use setwdrt(dir) to, roughly-speaking, setwd(paste0(customRroot, dir)). Advanced usage: use setrt(dir,name = "rootName") to name a custom root;
#' use setrt(name = "rootName") to switch the primary root to that named custom root; use getrts() to list all available custom roots and their names.
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
#' @param dir directory. In setrt if this is NULL, then name must be specified, and setrt makes the primary root the named custom root.
#' @param name name of custom root; defaults to "", which is the "current project root"
#' @examples
#'\dontrun{
#'
#' # Basic usage
#' setrt("~/Dropbox/myproject/") # set the root directory to myproject
#' setwdrt('data') # set the current working directory to ~/Dropbox/myproject/data/
#'
#' # Advanced usage
#' setrt("~/Dropbox/myproject/",name='main') # create a named custom root, 'main'
#' setrt("~/Dropbox/old/project/on/which/this/proj/depends/",name='dependsOn') # create a named custom root called 'dependsOn
#'
#' setrt(name='main') # now the primary project root is 'main'
#' setwdrt("data")
#' # do some work in the ~/Dropbox/myproject/data/ directory...
#'
#' setrt(name='dependsOn') # now the primary project root is 'dependsOn'
#' setwdrt("data")
#' # do some work in (e.g. get some data from) the ~/Dropbox/old/project/on/which/this/proj/depends/data directory
#'
#' getrts() # show all defined custom roots, in this case, 'main' and 'dependsOn'
#'
#'}
#'
#' @export
setrt <- function(dir = NULL,name="") {
  library(dplyr)
  library(stringr)
  if(!is.null(dir)) { # set custom root
    last.char <- stringr::str_split(dir,pattern="")[[1]] %>% .[length(.)]
    if(last.char!="/") dir <- paste0(dir,'/')
    options(setNames(object = list(dir),nm = paste0(name,'dismisc_root')))
  } else { # flip custom root
    if(name=="") {
      stop("If dir is unspecified, name should be a nonempty string.")
    } else {
        # flip custom root to name root
      if(is.null(getOption(paste0(name,"dismisc_root"),default=NULL))) {
        stop(paste0('Custom root is not defined.'))
      } else {
        options(dismisc_root = getOption(paste0(name,"dismisc_root"),default=NULL))
      }
    }
  }
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

#' @export
#' @rdname setrt
getrts <- function() {
  primaryrt <- options()[stringr::str_detect(names(options()),pattern = "(?<!.)dismisc_root")]
  allrts <- options()[stringr::str_detect(names(options()),pattern = "(?<=.)dismisc_root")]
  cat(paste0('primary (what setwdrt() refers to) \n\n', primaryrt))

  cat(paste0('\n\nall (what you can access using name="xyz") \n\n',"[name] = [directory]\n", paste0(paste0(stringr::str_replace(names(allrts),"dismisc_root","")," = ", allrts),collapse="\n")))
}





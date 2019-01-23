#' Go to an saved root directory.
#'
#' Basic usage: use setwd2rt(add='rootdir') to set the custom root; use setwd2rt() to go to the custom root; the root is saved as an option (see below), so will be preserved after an e.g. remove(list=ls()). Advanced usage: use setwd2rt(name='rootname',add='rootdir') to add the key-value pair ('rootname','rootdir') to the list of all rootdirs stored; use setwd2rt(name='rootname') to go to 'rootdir'; use setwd2rt(list=TRUE) to list all such key-value pairs.
#'
#' Best way to use this function
#'
#' \itemize{
#'   \item{in your init.R file that you run when you start working on a project}
#'     \itemize{
#'       \item{Use setwd2rt(add='rootdir') to specify the root folder of your data project as 'rootdir'}
#'       \item{Use setwd2rt(add='dependencyDir',name ="someDependency") to specify the root folder of some dependency (e.g. the data from another project that you are using in this project)}
#'     }
#'   \item{in your scripts, when you need to get to one of those roots}
#'    \itemize{
#'      \item{Use setwd2rt() to go to the 'default' root directory, defined earlier},
#'      \item{Use setwd2rt(name = "someDependency") to go to the subdir of that dependency defined earlier}
#'    }
#'    \item{every collaborator working on your project (e.g. synced via dropbox) should have his/her own init-collaborator-name.R file. This allows different collaborators to have different directory structures.}
#' }
#'
#' @param name Name of the root to go to, or to add. defaults to 'default'.
#' @param add directory to add
#' @param list if TRUE, directory is unchanged; a listing of all added roots is printed.
#'
#' @export
setwd2rt <- function(name = 'default', add = NULL, list = FALSE) {
  if(!is.null(add) & !list) { # add a custom root to the name-value pair list

    # default name is "default"
    last.char <- strsplit(add,split="")[[1]][[nchar(add)]]
    if(last.char!="/") add <- paste0(add,'/')


    options(setNames(object = list(add),nm = paste0(name,'dismisc_root')))

  } else if(!list) {

    if(is.null(getOption(paste0(name,"dismisc_root"),default=NULL))) {
      stop(paste0('Custom root is not defined.'))
    } else {
      setwd(getOption(paste0(name,"dismisc_root"),default=NULL))
    }

  }

  if(list) {
    primaryrt <- options()[stringr::str_detect(names(options()),pattern = "(?<!.)defaultdismisc_root")]
    allrts <- options()[stringr::str_detect(names(options()),pattern = "dismisc_root")]
    cat(paste0('default (what setwd2rt() goes to) \n\n', primaryrt))

    cat(paste0('\n\nall (move to these using setwd2rt(name="[name]")) \n\n',"[name] = [directory]\n", paste0(paste0(stringr::str_replace(names(allrts),"dismisc_root","")," = ", allrts),collapse="\n")))
  }

}

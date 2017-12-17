
#' Download all files in a list of URLs into the working directory
#'
#' @param url.vect vector of URLs. Files downloaded will be named according to part of the URL after the last forward slash '/'.
#' @param skip.already.downloaded whether to skip files that already exist. If FALSE, they are overwritten.
#' @param stub.vect vector of strings to paste0 to the front of destfile names, component-by-component. Use if the part after the last forward slash in the URLs is not unique.
#'
#' @return list of successfully downloaded destfile names
#' @export

download_them_all <- function(url.vect, skip.already.downloaded = TRUE,stub.vect = rep("",length(url.vect))) {
  destfilenames <- list()
  ii <- 0
  for(link in url.vect) {

    link %>% str_split(pattern="/") -> temp.list

    temp.list[[1]][[length(temp.list[[1]])]] -> temp.name

    if(skip.already.downloaded) {
      if(file.exists(temp.name)) {
        ii <- ii+1
        print(paste0("download_them_all: skipping ",ii," of ",length(link.vect)," destfile = ",temp.name))
        next
      }
    }
    ii <- ii+1
    print(paste0("download_them_all: downloading ",ii," of ",length(link.vect)," destfile = ",paste0(stub.vect[ii],temp.name)))
    tryCatch({
      download.file(url=link,
                  destfile=paste0(stub.vect[ii],temp.name),
                  quiet=TRUE) },
      error = function(e) {print(paste0(e,'; continuing')); next})
    destfilenames[[length(destfilenames)+1]] <- paste0(stub.vect[ii],temp.name)
  }
  return(destfilenames)
}

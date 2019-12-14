
#' Reverse arrows in code
#'
#' @param torev
#'
#' @return
#' @export
#'
#' @examples
reverse_arrows <- function() {
  library(stringr)

  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # find extra lines, they look like \n[ ]+\n
  selectedTextLast <- selectedText
  selectedText <- str_replace_all(selectedText,'\n[ ]*\n', ' \n cat(.putanewlinehere) \n ')
  while(selectedTextLast!=selectedText) {
    selectedTextLast <- selectedText
    selectedText <- str_replace_all(selectedText,'\n[ ]*\n', ' \n cat(.putanewlinehere) \n ')
  }

  selectedText <- parse(text=selectedText)
  selectedText <- as.character(selectedText)

  selectedText <- str_replace_all(selectedText,pattern=fixed('cat(.putanewlinehere)'),replacement='')

  tout <- paste0(selectedText, collapse = '\n')

  # selectedText <- str_split(selectedText, '\n')[[1]]

  # tout <- c()
  # for(torev in selectedText) {
  #   if(str_detect(torev,'->')) {
  #     torev <- str_split_fixed(torev,'->',2)
  #     torev <- rev(torev)
  #     torev <- paste0(torev[1],' <- ', torev[2])
  #   }
  #   torev <- str_trim(torev)
  #   tout <- c(tout,torev)
  # }
  #
  # tout <- paste0(tout,collapse = '\n')

  rstudioapi::insertText(tout)
}





#' Source() selected source
#'
#' Call this function as an addin to source() the selected text in the source pane.
#'
#' Doing this has advantages and disadvantages relative to ctrl+enter.
#' The main advantage is that if an error is thrown, then the whole script stops.
#' The main disadvantage is that nothing is printed to the console unless it is explicitly print()ed.
#' You can essentially think of the situation as "as if" the code was wrapped in \\{ \\}.
#'
#' @note Ctrl+enter copies the selected text from the source pane into the console line-by-line.
#' Therefore, there is no way a script can stop the remainder of the script from running in this case (using stop, stopifnot, etc.).
#' One way around this is to surround your code with \\{ \\} and then run the whole block. This way, the whole block is like one line in the console.
#' So if there is an error in the block the whole block dies. (The same thing happens with functions.)
#' However, having to wrap my code with curly braces all the time, or always use functions, is quite annoying in my opinion.
#'
#'
#' @export
source_selected_source <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # if selectedText is "", expand it to the complete line where the cursor is
    # this is the default behavior of ctrl+enter
  if(selectedText=="") {
    temp$selection[[1]]$range$start[['row']] -> rownum
    temp$contents[[rownum]] -> selectedText
  }

  tryCatch(expr = {source(textConnection(selectedText), echo = TRUE)},
           error = function(e) { message(paste0("Error in source:", e)); return() })
}

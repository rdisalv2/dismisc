#' Source() selected source
#'
#' Call this function as an rstudio addin to source() the selected text in the source pane.
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


#' Execute SQLite
#'
#' Call this function as an rstudio addin to push to a con with dbExecute
#'
#' note that you cannot use double quotes:
#' http://stackoverflow.com/questions/1992314/what-is-the-difference-between-single-and-double-quotes-in-sql
#'
#' @return
#' @export
#'
#' @examples
dbExecute_selected_sqlite <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # if selectedText is "", expand it up until you see a semicolon ;
  # because that's how SQL code works.

  # to do this:

  # old version:
  # if selectedText is "", expand it to the complete line where the cursor is
  # this is the default behavior of ctrl+enter
  # if(selectedText=="") {
  #   temp$selection[[1]]$range$start[['row']] -> rownum
  #   temp$contents[[rownum]] -> selectedText
  # }

  # construct "commandText"
  commandText = paste0('dbExecute(con,"',selectedText,'")')

    # dbExecute(con,
    #                       "CREATE TABLE intakesDailyWeather
    #       AS SELECT intakes.pwsid, intakes.unique_pwsintake_id,intakes.state, schlenker.dateNum, schlenker.tMin, schlenker.tMax, schlenker.prec,
    #       FROM intakes
    #       INNER JOIN schlenker
    #       ON intakes.gridNumber=schlenker.gridNumber")

  tryCatch(expr = {source(textConnection(commandText), echo = TRUE)},
           error = function(e) { message(paste0("Error in source:", e)); return() })
}

#' Get query SQLite
#'
#' Call this function as an rstudio addin to push to a con with dbGetQuery
#'
#' This is useful to e.g. displaying tables.
#'
#' note that you cannot use double quotes:
#' http://stackoverflow.com/questions/1992314/what-is-the-difference-between-single-and-double-quotes-in-sql
#'
#' @return
#' @export
#'
#' @examples
dbGetQuery_selected_sqlite <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # if selectedText is "", expand it up until you see a semicolon ;
  # because that's how SQL code works.

  # if selectedText is "", expand it up until you see a semicolon ;
  # because that's how SQL code works.

  # to do this:
  # (1) expand to current line. trim whitespace. If it ends with a ;, stop.
  # (2) expand to next line. trim whitespace if it ends with a ;, stop.
  # (3) continue until you hit a ;
  # then, reverse the process --
  # expand backwards until you hit a ;
  # then, finally, set cursor position
  if(selectedText=="") {
    temp$selection[[1]]$range$start[['row']] -> rownum
    temp$contents[[rownum]] -> selectedText
    selectedText <- trimws(selectedText)
    last_char <- substr(selectedText,start = nchar(selectedText),stop = nchar(selectedText))
    # expand forward
    while(last_char != ';' & rownum < length(temp$contents)) {
      rownum <- rownum + 1
      temp$contents[[rownum]] -> selectedText_temp
      selectedText <- paste0(selectedText,'\n',selectedText_temp)
      selectedText <- trimws(selectedText)
      last_char <- substr(selectedText,start = nchar(selectedText),stop = nchar(selectedText))
    }
    place_to_put_cursor <- rownum+1

    # expand backward
    temp$selection[[1]]$range$start[['row']] -> rownum
    rownum <- rownum - 1

    if(rownum>=1) {
      temp$contents[[rownum]] -> selectedText_temp # this is the previous row
      selectedText_temp <- trimws(selectedText_temp)
      last_char <- substr(selectedText_temp,start = nchar(selectedText_temp),stop = nchar(selectedText_temp))
      while(last_char != ';' & rownum >= 1 & last_char != '') {
        selectedText <- paste0(selectedText_temp,'\n',selectedText)

        rownum <- rownum - 1
        if(rownum>=1) {
          temp$contents[[rownum]] -> selectedText_temp # this is the previous row
          selectedText_temp <- trimws(selectedText_temp)
          last_char <- substr(selectedText_temp,start = nchar(selectedText_temp),stop = nchar(selectedText_temp))
        }
      }
    }

    # now advance cursor to rownum + 1
    rstudioapi::setCursorPosition(c(place_to_put_cursor,1,place_to_put_cursor,1))
  } else { # in this case, there is some mass to selectedText
    # because dbGetQuery and dbExecute only allow one command at a time
    # the approach I take is to tokenize by ; using strsplit
    # then shove in one at a time

    selectedText <- paste0(unlist(strsplit(selectedText,split = ';',fixed=TRUE)),';')



  }



  # old version:
  # if selectedText is "", expand it to the complete line where the cursor is
  # this is the default behavior of ctrl+enter
  # if(selectedText=="") {
  #   temp$selection[[1]]$range$start[['row']] -> rownum
  #   temp$contents[[rownum]] -> selectedText
  # }

  selectedText_charvect <- selectedText
  for(selectedText in selectedText_charvect) {
      # final sanitation to avoid needless errors
      selectedText <- trimws(selectedText)
      if(selectedText=='' | selectedText==';') next

      # construct "commandText"
      commandText = paste0('dbGetQuery(con,"',selectedText,'")')

      # run it!
      tryCatch(expr = {source(textConnection(commandText), echo = TRUE)},
               error = function(e) { message(paste0("Error in source:", e)); return() })
  }


  # dbExecute(con,
  #                       "CREATE TABLE intakesDailyWeather
  #       AS SELECT intakes.pwsid, intakes.unique_pwsintake_id,intakes.state, schlenker.dateNum, schlenker.tMin, schlenker.tMax, schlenker.prec,
  #       FROM intakes
  #       INNER JOIN schlenker
  #       ON intakes.gridNumber=schlenker.gridNumber")

}


#' Wrap select lines in dbGetQuery(con,...)
#'
#' @return
#' @export
#'
#' @examples
wrap_in_dbGetQuery <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # break up selectedText by ;
  selectedText <- paste0(unlist(strsplit(selectedText,split = ';',fixed=TRUE)),';')

  output <- c()
  selectedText_charvect <- selectedText
  for(selectedText in selectedText_charvect) {
    # final sanitation to avoid needless errors
    selectedText <- trimws(selectedText)
    if(selectedText=='' | selectedText==';') next

    # construct "commandText"
    commandText = paste0('dbGetQuery(con,"',selectedText,'")')

    output <- c(output,commandText)

  }
  output <- paste0(output,collapse='\n')
  cat(output)
  rstudioapi::sendToConsole(output,execute=FALSE)
}




#' send stata code to terminal via temporary do file
#'
#' @return
#' @export
#'
#' @examples
do_stata <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # create tempfile
  tfile <- tempfile(fileext = '.do')

  # write to tfile
  writeLines(selectedText,tfile)

  # send to console
  print(paste0('do "',tfile,'"'))

  # send to terminal
  # print(rstudioapi::terminalList())
  visiterm <- rstudioapi::terminalVisible()
  print(visiterm)
  rstudioapi::terminalSend(id = visiterm, text = paste0('do "',tfile,'"'))
  rstudioapi::terminalSend(id = visiterm, text='\n')
  # rstudioapi::terminalSend()



  # capture text, send to console
  # print(paste0(readLines(con = tfile),collapse='\n'))


  # print(selectedText)
}



#' send stata code line-by-line
#'
#' Automatically strips // from selected code
#'
#' @return
#' @export
#'
#' @examples
do_lbyl_stata <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  selectedText <- strsplit(selectedText,'\n')[[1]]
  print('before -----------------')
  print(selectedText)

  # #single line comment flag
  # sing_line <- 0
  # #multi line comment flag
  # mult_line <- 0
  # # iterate over characters in selectedText
  #
  # # print(selectedText)
  # selectedText <- strsplit(selectedText,split = '')[[1]]
  # print(selectedText)
  #
  # newText <- ''
  # for(ii in 1:nchar(selectedText)) {
  #   k <- selectedText[ii]
  #   if(k=='*')
  #
  #   newText <- paste0(newText,k)
  #
  # }


  # # print(temp)
  # temp[1] <- ifelse(is.na(temp[1]),'',temp[1])
  # selectedText[ii] <- temp[1]
  #
  #
  # # strip *,  // and /* */ sections
  #
  # strip //'s
  for(ii in 1:length(selectedText)) {
    # print(selectedText[ii])
    # print(class(selectedText[ii]))
    temp <- strsplit(selectedText[ii],split = '//',fixed = TRUE)[[1]]

    # print(temp)
    temp[1] <- ifelse(is.na(temp[1]),'',temp[1])
    selectedText[ii] <- temp[1]
  }
  # strip *'s
  for(ii in 1:length(selectedText)) {
    # print(selectedText[ii])
    # print(class(selectedText[ii]))
    temp <- stringr::str_trim(selectedText[ii])
    temp <- ifelse(stringr::str_sub(temp,1,1)=='*','',temp)
    selectedText[ii] <- temp
  }
  #
  # # strip /* */'s
  # b/c these can be multiline need to create an iterator
  # #multi line comment flag
  mult_line <- 'none'
  newText <- ''
  selectedText <- paste0(selectedText,collapse='\n')
  selectedText <- strsplit(selectedText,'')[[1]]
  for(ii in 1:length(selectedText)) {
    k <- selectedText[ii]
    if(ii<length(selectedText)) j <- selectedText[ii+1]
    else j <- 'END OF LINE'
    if(mult_line == 'none') {
      if(k=='/' & j == '*') mult_line <- 'erase'
    }
    if(mult_line == 'erase') {
      if(k=='*' & j=='/') multi_line = "none"
    }

    if(mult_line == 'none') newText <- paste0(newText,k)
  }


  print('after ---------------------')
  cat(newText)

  # send to terminal
  # print(rstudioapi::terminalList())
  visiterm <- rstudioapi::terminalVisible()
  print(visiterm)
  rstudioapi::terminalSend(id = visiterm, text = newText)
  rstudioapi::terminalSend(id = visiterm, text='\n')

}




#' send python code line-by-line
#'
#' Automatically strips # from selected code
#'
#' @return
#' @export
#'
#' @examples
do_lbyl_python <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  selectedText <- strsplit(selectedText,'\n')[[1]]
  print('before -----------------')
  print(selectedText)

  # strip #'s
  for(ii in 1:length(selectedText)) {

    temp <- strsplit(selectedText[ii],split = '#',fixed = TRUE)[[1]]

    temp[1] <- ifelse(is.na(temp[1]),'',temp[1])
    selectedText[ii] <- temp[1]
  }

  # send to terminal
  # print(rstudioapi::terminalList())
  # visiterm <- rstudioapi::terminalVisible()
  # print(visiterm)
  # rstudioapi::terminalSend(id = visiterm, text = newText)
  # rstudioapi::terminalSend(id = visiterm, text='\n')
  visiterm <- rstudioapi::terminalVisible()
  # print(visiterm)

  print('after ---------------')
  print(selectedText)

  for(ss in selectedText) {
    if(stringr::str_trim(ss)=='') next
    print(paste0('SENDING = ',ss))
    rstudioapi::terminalSend(id = visiterm, text = ss)
    rstudioapi::terminalSend(id = visiterm, text = '\n')
    # print(ss)
    # print('\n')
  }
  # rstudioapi::termin

  rstudioapi::terminalSend(id = visiterm,
                           text = paste0('%run "', , '"'))


}




#' run python code using %run
#' @return
#' @export
#'
#' @examples
run_python <- function() {
  # get selected text in the source pane
  rstudioapi::getSourceEditorContext() -> temp

  temp$selection[[1]]$text -> selectedText

  # save to an ipy file
  tfile <- tempfile(fileext = '.ipy')

  # write to tfile
  writeLines(selectedText,tfile)

  visiterm <- rstudioapi::terminalVisible()

  rstudioapi::terminalSend(id = visiterm, text = paste0('%run ',tfile))
  rstudioapi::terminalSend(id = visiterm, text = '\n')

}







#' Overwrite of addPlots in WordR package, to not crash if a plot isn't in the docx. see WordR::addPlots for details
#'
#' @return
#' @export
addPlots2 <- function (docxIn, docxOut, Plots = list(), width = 6, height = 6,
                       res = 300, style = NULL, debug = F, ...)
{
  if (debug) {
    browser()
  }

  doc <- officer::read_docx(path = docxIn)
  bks <- gsub("^p_", "", grep("^p_", officer::docx_bookmarks(doc),
                              value = T))
  for (bk in bks) {
    if (!bk %in% names(Plots)) {
      warning(paste(bk, "not in the Plots list"))
    } else {
      doc <- officer::cursor_bookmark(doc, paste0("p_", bk))
      pngfile <- tempfile(fileext = ".png")
      grDevices::png(filename = pngfile, width = width, height = height,
                     units = "in", res = res, ...)
      Plots[[bk]]()
      grDevices::dev.off()
      doc <- officer::body_add_img(doc, pngfile, style = style,
                                   width = width, height = height, pos = "on")
    }
  }
  print(doc, target = docxOut)
  return(docxOut)
}


#' Standard conversion to flextables
#'
#' @param out A dataframe, columns need to be C1-CN, actual headers in first row.
#' @param nblankheaders The number of columns without parentheses numbers over them; default 1.
#' @param boldheaders The headers will be automatically bold
#'
#' @return
#' @export
flextable_convert_standard <- function(out,nblankheaders=1, boldheaders = TRUE) {
  ft_out <- flextable(out,cwidth=1)

  f <- function(...) {
    flextable::set_header_labels(ft_out,...)
  }

  ft_out <- do.call(f,
                    as.list(setNames(c(rep('',nblankheaders),paste0('(',1:(ncol(out)-nblankheaders),')')),
                                     paste0('C',1:(ncol(out))))))

  # border on each row, by default
  ft_out <- flextable::border(ft_out, i=1:nrow(out),j=1:ncol(out),border.bottom = fp_border(color='black'))

  return(ft_out)
}

#' Get stars of p-value for word papers.
#'
#' @param x pvalue
#'
#' @return stars
#' @export
w_pstar <- function(x) {
  t_pstar(x) %>% str_extract('(\\*)+') %>% {ifelse(is.na(.),'',.)}
}




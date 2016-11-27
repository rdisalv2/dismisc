# dismisc: miscellaenous R functions


# Guidance


In my projects I always have an init.R script that I run before all others. It varies based on project but typically looks like this:

library(statar) # essentially for tab(), which I use quite often for simple tabulations (anything serious is done through dplyr chains with summarize(), so I don't take tab() very seriously -- I think tab()'s creator Matthieu Gomez thinks the same way). There are other useful functions in here, especially tlead tlag and join.

library(magrittr) # for %<>% and %$%, which I use quite often, in spite of being told not too.
library(purrr) # for the map functions and safely()
library(dplyr) # the main workhorse
library(readr)
library(stringr)
library(reshape2) # I still use reshape2::melt and reshape2::dcast, although I've seen people using tidyr::gather and tidyr::spread for the same purpose. One of my goals is to switch to tidyr, but it is hard since reshape2 is already very intuitive.
library(ggplot2) # for plotting

library(dismisc) # this package

setrt("path/to/root/of/project") # use dismisc::setrt to set the project root directory; will be used in all other scripts by setwdrt()


# Functions in dismisc

## setrt() and setwdrt()

These functions allow you to pretend to have a different root directory. This is useful for projects on multiple computers with different directory structures.

The way this works: setrt stores a global option in dismisc_root. Then, roughly-speaking, setwdrt(x) calls setwd(paste0(dismisc_root,x)).

Projects can have multiple roots, which can be used like paths to dependencies. See ?setrt for details.

## Misc functions

* clear_all_labels(df) - removes all labels from the columns of the dataframe df (there may be a better way)

* get_non_numerics(x) - given a vector returns the subvector that will go to NA when coerced

* download_them_all() - downloads files in a list of links

* dismisc_extrapolate() - extrapolate in a grouped dplyr::mutate using stats::splines or lm. (Special name to avoid conflicts.)

* mdb_get() - a simplified version of Hmisc::mdb.get.

* parse_censored_data_edfacts() - parses a particular time of numerically censored data. (Special name to avoid conflicts; named this way because edfacts data has this structure, although I've seen it elsewhere too.)

## Possible replacements?

* get_non_numerics(). Maybe just do c("1","3","h","i","32","32.32") %>% .[is.na(as.numeric(.))] -- It's almost as much typing.

# Functions removed when I moved from library(disalvo) to library(dismisc), with comments

These comments might help people who are trying to figure out how to solve certain common data problems that sound like they need a new function but actually can be solved easily with dplyr etc.

* db_init(). Don't make a function to load libraries etc.; make a script init.R for each project instead. This way you can call setrt() in the init.R script.

* cols.to.char(). Instead, use df %<>% mutate_all(funs(as.character(.))) 

* lager()/leader(). Instead use statar::tlag in a dplyr::mutate.

* print.db.table() and other xtable hacks. Instead use R.rsp with a latex template file. More details on this in a future version of dismisc.

* empty.string.to.NA(). I used to use this a lot so that foreign::write.dta() worked. Instead use df %<>% mutate_all(funs(ifelse(.=="",NA,.))). Proof:

df <- data_frame(x = c("a","b",""), y = 1:3)
df %>% mutate_all(funs(ifelse(.=="",NA,.)))

* convertsp2.names and convert_2.names. Just do names(df) %<>% str_replace_all(pattern = "[ ]", replacement = ".") etc.






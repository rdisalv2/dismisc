df <- data_frame(x = c("a","b",""), y = 1:3)
df %>% mutate_all(funs(ifelse(.=="",NA,.)))

# map_lgl(c("1","3","h"),is.na(as.numeric(.)))




library(statar)

?statar::join

statar::join

?statar::count
count(1:100, c(NA, 1:101))

?statar::count
?dplyr::count

?statar::tab

library(magrittr)

library(Lahman)
batting_tbl <- tbl_df(Batting)

batting_tbl
plays_by_year <- group_by(batting_tbl, playerID, stint) %>% tally(sort = TRUE)
plays_by_year
tally(plays_by_year, sort = TRUE)
tally(plays_by_year, sort = TRUE) %>% tally(sort=TRUE)

batting_tbl$stint[1] <- NA
batting_tbl %>% group_by(playerID) %>% tab(stint)

plays_by_year %<>% ungroup


tab(plays_by_year,n)

library(dplyr)
if (require("Lahman")) {
  batting_tbl <- tbl_df(Batting)
  tally(group_by(batting_tbl, yearID))
  tally(group_by(batting_tbl, yearID), sort = TRUE)

  # Multiple tallys progressively roll up the groups
  plays_by_year <- tally(group_by(batting_tbl, playerID, stint), sort = TRUE)
  tally(plays_by_year, sort = TRUE)
  tally(tally(plays_by_year))

  # This looks a little nicer if you use the infix %>% operator
  batting_tbl %>% group_by(playerID) %>% tally(sort = TRUE)

  # count is even more succinct - it also does the grouping for you
  batting_tbl %>% count(playerID)
  batting_tbl %>% count(playerID, wt = G)
  batting_tbl %>% count(playerID, wt = G, sort = TRUE)
}





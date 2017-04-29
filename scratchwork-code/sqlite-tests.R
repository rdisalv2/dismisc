
# packages needed to use sqlite in R
library(RSQLite)
library(sqldf)
library(DBI)
library(dplyr)

# general patterns:
# start up sqlite
con <- dbConnect(RSQLite::SQLite(), "temp_db.sqlite")

iris$rowid <- 1:nrow(iris)
iris %>% dbWriteTable(con,'iris',
                      ., row.names = NA, overwrite = TRUE, append = FALSE,
                      field.types = NULL)

df <- dbGetQuery(con,
           statement =
             "SELECT * FROM iris LIMIT 10;")

# dbExecute(con,
#            statement =
#              '')



?dbListTables
# from now on we'll assume that con points to the sqlite database that you are manipulating. the
# dismisc::source_selected_sqlite will pass sqlite commands to con like:
dbExecute(con,
          "CREATE TABLE intakesDailyWeather
          AS SELECT intakes.pwsid, intakes.unique_pwsintake_id,intakes.state, schlenker.dateNum, schlenker.tMin, schlenker.tMax, schlenker.prec
          FROM intakes
          INNER JOIN schlenker
          ON intakes.gridNumber=schlenker.gridNumber")

# eventually you'll move this to R

# write a SQL table to that file database, containing the intake location data:
intakes$unique_pwsintake_id <- 1:nrow(intakes)
intakes %>% dbWriteTable(con, 'intakes',
                         ., row.names = NA, overwrite = TRUE, append = FALSE,
                         field.types = NULL)
# write another SQL table, containing all of the daily weather data:
schlenker %>% dbWriteTable(con, 'schlenker',
                           ., row.names = NA, overwrite = TRUE, append = FALSE,
                           field.types = NULL)

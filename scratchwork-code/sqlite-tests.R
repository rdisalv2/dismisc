
######################################################
# dbExecute(con,
#            statement =
#              '')

colnamesiris <- dbGetQuery(con,
                           statement = "SELECT * FROM iris LIMIT 0;")


df <- dbGetQuery(con,
                 statement = "SELECT * FROM temp1;")

iris2 <- iris %>% select(slength = Sepal.Length,
                         swidth = Sepal.Width,
                         Species,
                         rowid)

library(reshape2)
library(magrittr)
iris2 %<>% melt(id.vars = c('rowid'))

View(iris2)


for(ii in 1:5) {
  con %>% dbExecute('DROP TABLE IF EXISTS temp' %>% paste0(ii))
}

# con = connection
melt_sqlite <- function(con, table, outTable, id.vars) {
  # table <- 'iris2' # for testing only!
  # id.vars <- 'rowid'

  dbGetQuery(con,paste0('DROP TABLE IF EXISTS ', outTable))

  column_names <- names(dbGetQuery(con,paste0("SELECT * FROM ", table, " LIMIT 0;")))

  measure.vars <- setdiff(column_names,id.vars)

  # get number of measure.var columns
  num.measure.vars <- length(measure.vars)

  # drop all temporaryTables
  for(ii in 1:num.measure.vars) {
    con %>% dbExecute('DROP TABLE IF EXISTS temporaryTable' %>% paste0(ii))
  }

  for(ii in 1:num.measure.vars) {
    mm <- measure.vars[ii]
    dbGetQuery(con,paste0("CREATE TABLE temporaryTable", ii," AS
              SELECT ", paste0(id.vars,collapse=', '),", '",
                          mm,
                          "' AS variable, CAST(",mm, " AS TEXT) AS value
              FROM ", table, ";"))
  }

  # create outTable
  dbGetQuery(con,paste0('CREATE TABLE ', outTable,
                        '(', paste0(id.vars, ' TEXT',collapse=','),
                        ', variable TEXT, value TEXT)'))

  # collect all temporaryTables
  for(ii in 1:num.measure.vars) {
    dbGetQuery(con,paste0("INSERT INTO ", outTable,
                    " SELECT * FROM temporaryTable", ii,";"))
    con %>% dbExecute('DROP TABLE IF EXISTS temporaryTable' %>% paste0(ii))
  }

}

melt_sqlite(con,table = 'iris2', outTable = 'iris2Melt', id.vars = 'rowid')

iris2Melt <- dbGetQuery(con,"SELECT * FROM iris2melt;")

iris2
sum(iris2==iris2Melt)

failures <- (iris2Melt!=iris2)
failures %>% rowSums -> temp
iris2[temp>0,] %>% View(title='fail_melt')
iris2Melt[temp>0,] %>% View(title='fail_sql')

dcast_sqlite <- function(con, LHS, RHS, table, outTable, value.var = 'value') {
  stopifnot(length(RHS)==1) # right now, can only dcast one RHS at a time...

  dbGetQuery(con,paste0('DROP TABLE IF EXISTS ', outTable))

  # LHS <- 'rowid' # for testing only!
  # RHS <- 'variable'
  # table <- 'iris2melt'
  # outTable <- 'iris2cast'
  # value.var <- 'value'

  RHS.values <- dbGetQuery(con,paste0("SELECT DISTINCT ", RHS, " FROM ", table, ";"))

  # build statement
  command <- paste0("CREATE TABLE ", outTable,
         " AS SELECT ", paste0(LHS, collapse=', '))

  for(rr in RHS.values[[RHS]]) {
    command <- paste0(command, ', ',
                      "MAX(CASE WHEN (variable = '", rr, "') THEN ", value.var, ' ELSE NULL END) as ', rr)
  }

  command <- paste0(command,' FROM ',table, ' GROUP BY ', paste0(LHS,collapse = ','), ';')

  dbGetQuery(con,command)

}

dcast_sqlite(con, LHS = 'rowid', RHS = 'variable', table = 'iris2melt',outTable = 'iris2cast',value.var='value')



iris2cast <- dbGetQuery(con,"SELECT * FROM iris2cast;")

View(iris2cast)

#
# ?dbListTables
# # from now on we'll assume that con points to the sqlite database that you are manipulating. the
# # dismisc::source_selected_sqlite will pass sqlite commands to con like:
# dbExecute(con,
#           "CREATE TABLE intakesDailyWeather
#           AS SELECT intakes.pwsid, intakes.unique_pwsintake_id,intakes.state, schlenker.dateNum, schlenker.tMin, schlenker.tMax, schlenker.prec
#           FROM intakes
#           INNER JOIN schlenker
#           ON intakes.gridNumber=schlenker.gridNumber")
#
# # eventually you'll move this to R
#
# # write a SQL table to that file database, containing the intake location data:
# intakes$unique_pwsintake_id <- 1:nrow(intakes)
# intakes %>% dbWriteTable(con, 'intakes',
#                          ., row.names = NA, overwrite = TRUE, append = FALSE,
#                          field.types = NULL)
# # write another SQL table, containing all of the daily weather data:
# schlenker %>% dbWriteTable(con, 'schlenker',
#                            ., row.names = NA, overwrite = TRUE, append = FALSE,
#                            field.types = NULL)

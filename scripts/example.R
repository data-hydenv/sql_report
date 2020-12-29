# you need to install most of this stuff first
require(RPostgreSQL)
require(readr)
require(ggplot2)
require(reshape2)

# This is a really quick script, used as prove of concept.
# please to not spread scripts like this -> write functions  
# I will update it soon

# make a database connection
drv <- dbDriver('PostgreSQL')
# set the environment variable fist like: export POSTGRESS_PASSWORD=yourpassword
# I have issues with RStudio from time to time using this approach, cause it's not 
# super transparent, which console session it is using...
con <- dbConnect(drv, host='localhost', port=5432, user='hydenv', password=Sys.getenv('POSTGRES_PASSWORD'), dbname='hydenv')

# get the sql code
sql <- read_file('../sql/example_analysis.sql')

# run query
result <- dbGetQuery(con, sql)

# always close connections
dbDisconnect(con)

# open a pdf
pdf('../figures/example_analysis.pdf')

# make the graph
ggplot(melt(result), aes(x=variable, y=value)) + 
  geom_boxplot(aes(fill=variable))

dev.off()

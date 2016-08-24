options(encoding="utf-8")
library("RSQLite")
library(quantmod)
library(xts)

sqlite <- dbDriver("SQLite")
con <- dbConnect(sqlite,"/home/young/work/a_market/db/test_database.sqlite3")
yahoo_dates <- dbGetQuery(con,'select * from yahoo_dates WHERE company_id = 1341')

yahoo_dates <- data.frame(Date=as.Date(yahoo_dates$date),Open=yahoo_dates$open,High=yahoo_dates$high,Low=yahoo_dates$low,Close=yahoo_dates$close,Volume=yahoo_dates$vol,Adjusted=yahoo_dates$adj_close,stringsAsFactors=FALSE)

date <- yahoo_dates$Date
yahoo_dates$Date <- NULL
sl <- xts(yahoo_dates,order.by=date)
# sl$Date <- NULL
# head(sl)
chartSeries(sl)

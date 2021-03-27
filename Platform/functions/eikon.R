library(tidyverse)
library(devtools)
library(eikonapir)

Sys.setenv(TZ = 'EST')
eikonapir::set_proxy_port(9000L)

# API
eikon_api = "9a548e9c62cb499b8ebd0d9a777b4d857ef449a0"

#add my key
eikonapir::set_app_id(eikon_api)
# result <- get_symbology(list("MSFT.O", "GOOG.O", "IBM.N"),"RIC",list("ISIN"),raw_ouput = FALSE,debug=FALSE)
# df = get_timeseries("MSFT.O",list("*"),start_date = "2016-01-01T15:04:05",end_date = "2021-03-22T15:04:05",interval = "daily", raw_output = TRUE)
# dat = get_timeseries("MSFT.O",list("*"),start_date = "2016-01-04T00:00:00Z",end_date ="2021-03-22T00:00:00Z","daily")


y <- substr(as.character(Sys.time()), start = 1, stop = 4)
m <- substr(as.character(Sys.time()), start = 6, stop = 7) 
d <- substr(as.character(Sys.time()), start = 9, stop = 10)

current <- paste0(y, "-", m, "-", d, "T00:00:00Z")

eikon_get <-
function(sym, sdate = "2000-01-01T00:00:00", edate = current ) {
    require(tidyverse)
    require(devtools)
    require(eikonapir)
    require(lubridate)
    require (xts)
    # create a vector with all linesye
   dt <- tryCatch(get_timeseries(sym,fields = "*",
                            start_date = sdate ,
                            end_date =  edate,
                            debug = FALSE)) 
  
    df <- tibble (  
                    'Date'= substr(as.character(dt$TIMESTAMP), start = 1, stop = 10),
                    # 'Date'= ymd(substr(as.character(dt$TIMESTAMP), start = 1, stop = 10)),
                    'Open' = dt$OPEN,
                    'High' = dt$HIGH,
                    'Low'  = dt$LOW,
                    'Close' = dt$CLOSE,
                    'Count' = dt$COUNT,
                    'Volume' = dt$VOLUME,
                    'Ric'  = sym
                   )
    # names(df )[2:6] <- paste0( paste0(names(df )[2:6], '.', sym))
    # tsdata <- xts (x = df[,-1], order.by = as.Date(as.character(df[,1]), format = "%Y-%m-%d") )
    return(df)

}


# #### transform data frame into timeseries ####
# transforn_into_xts <- function (df) {
#   dates <- as.Date(as.character(df[,1]), format = "%Y-%m-%d")
#   data  <- df[,-1]
#   #
#   tsdata <- xts( x = data, order.by = dates)
# }
####

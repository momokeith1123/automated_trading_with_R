library(devtools)
library(eikonapir)

Sys.setenv(TZ = 'EST')
eikonapir::set_proxy_port(9000L)

# API
eikon_api = "9a548e9c62cb499b8ebd0d9a777b4d857ef449a0"

#add my key
eikonapir::set_app_id(eikon_api)
result <- get_symbology(list("MSFT.O", "GOOG.O", "IBM.N"),"RIC",list("ISIN"),raw_ouput = FALSE,debug=FALSE)
df = get_timeseries(list("MSFT.O","VOD.L","IBM.N"),list("*"),"2016-01-01T15:04:05","2016-01-10T15:04:05","daily")


y <- as.numeric(substr(as.character(Sys.time()), start = 1, stop = 4))
m <- as.numeric(substr(as.character(Sys.time()), start = 6, stop = 7)) 
d <- as.numeric(substr(as.character(Sys.time()), start = 9, stop = 10))

current <- paste0(y, "-", m, "-", d, "T16:45:00")

eikon_get <-
function(sym, sdate = "2000-01-01T16:45:00", edate = current ) {
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
  
    df <- tibble (  'Dates'= ymd(substr(as.character(dt$TIMESTAMP), start = 1, stop = 10)),
                    'OPEN' = as.double(dt$OPEN),
                    'HIGH' = as.double(dt$HIGH),
                    'LOW'  = as.double(dt$LOW),
                    'CLOSE' = as.double(dt$CLOSE),
                    'COUNT' = as.double(dt$COUNT),
                    'VOLUME' = as.double(dt$VOLUME),
                    'RIC'  = sym
                   )
    # names(df )[2:6] <- paste0( paste0(names(df )[2:6], '.', sym))
    
    return(df)

}


eikon_get <-
function(sym, sdate = "2000-01-01T16:45:00", edate = current ) {
    require(tidyverse)
    require(devtools)
    require(eikonapir)
    require(lubridate)
    require (xts)
    # create a vector with all linesye
    dt <- tryCatch(get_timeseries(rics = sym,
                                  fields = "*",
                                  start_date = sdate ,
                                  end_date =  edate,
                                  interval = "daily",
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

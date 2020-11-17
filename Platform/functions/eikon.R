library(devtools)
library(eikonapir)

Sys.setenv(TZ = 'UTC')
eikonapir::set_proxy_port(9000L)

# API
eikon_api = "9a548e9c62cb499b8ebd0d9a777b4d857ef449a0"

#add my key
eikonapir::set_app_id(eikon_api)

y <- as.numeric(substr(as.character(Sys.time()), start = 1, stop = 4))
m <- as.numeric(substr(as.character(Sys.time()), start = 6, stop = 7)) 
d <- as.numeric(substr(as.character(Sys.time()), start = 9, stop = 10))

current <- paste0(y, "-", m, "-", d, "T00:00:00")

eikon_get <-
function(sym, sdate = "2020-11-01T00:00:00", edate = current ) {
    require(devtools)
    require(eikonapir)
    
    # create a vector with all linesye
    tryCatch(get_timeseries(sym,
                            start_date = sdate ,
                            end_date =  edate,
                            debug = FALSE))
}

# dt <-eikon_get('HFC')
# ticker <- list ('AAPL.O', 'MSFT.O') %>% set_names(c('Apple Inc', 'Microsoft Corp'))
# df <- map (ticker, ~ get_timeseries(.x, start_date = "2016-01-04T00:00:00", end_date =  "2020-11-16T00:00:00",debug = FALSE) )
df =get_timeseries (as.list ('AAPL.O'),list("*"),start_date = "2016-01-04T00:00:00", end_date =  "2020-11-16T00:00:00",debug = FALSE)


ticker <- list ('AAPL.O', 'MSFT.O') %>% set_names(c('Apple Inc', 'Microsoft Corp'))


df <- map (ticker, ~ get_timeseries(.x, start_date = "2016-01-04T00:00:00", end_date =  "2020-11-16T00:00:00",debug = FALSE) )

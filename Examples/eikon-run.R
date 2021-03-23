
# set root as working directory, change it to your wd

root <- "D:/repositories/automated_trading_with_R/Examples"
setwd(root)

# delete AutoTrading folder if exists. We will start fresh
if(file.exists("./AutoTrading")) {
  unlink("./AutoTrading", recursive=TRUE)
}
# create AutoTrading folders
dir.create("./AutoTrading")
dir.create("./AutoTrading/stockdata")
dir.create("./Autotrading/functions")

####Listing 2.1: Setting Path Variables
rootdir <- paste0(root,"/Autotrading")
datadir <- paste0(root,"/AutoTrading/stockdata/")
functiondir <- paste0(root,"/AutoTrading/functions/")
####

####Listing 2.2 modified for quandl instead of Yahoo!
#insert your Quandl APO here
require(eikonapir)
eikon_api = "9a548e9c62cb499b8ebd0d9a777b4d857ef449a0"


#add my key
eikonapir::set_app_id(eikon_api)

y <- as.numeric(substr(as.character(Sys.time()), start = 1, stop = 4))
m <- as.numeric(substr(as.character(Sys.time()), start = 6, stop = 7)) 
m <- '02'
d <- as.numeric(substr(as.character(Sys.time()), start = 9, stop = 10))

current <- paste0(y, "-", m, "-", d, "T16:45:00")

# current <- Sys.time()

# this function downloads the columns needed as from start_date
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


# save quandl.R file in /functions with 'quandl'_get function
setwd(functiondir)
dump(list = c("eikon_get"), "eikon.R")

S <- c("AAPL.O","ABMD.O","ALXN.O","AVGO.O","AMZN.O")

#### 2.4
# Load "invalid.R" file if available
invalid <- character(0)
setwd(rootdir)
if("invalid.R" %in% list.files()) source("invalid.R")



# Find all symbols not in directory and not missing
setwd(datadir)
toload <- setdiff(S[!paste0(S, ".csv") %in% list.files()], invalid)

#load new column names
column_names <- c("Open", "High", "Low", "Close", "Volume")


# Fetch symbols with quandl_get function, save as .csv or missing
source(paste0(functiondir, "eikon.R"))
if(length(toload) != 0){
  for(i in 1:length(toload)){
    
    df <- eikon_get(toload[i])
    
    if(!is.null(df)) {
      #changing names
      colnames(df) <- column_names
      # as zoo objects downloaded, row names must be TRUE. Use write ZOO
      write.zoo(df, file = paste0(toload[i], ".csv"))
    } else {
      invalid <- c(invalid, toload[i])
    }
    
  }
}

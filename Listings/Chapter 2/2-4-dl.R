require(tidyverse)
# Load "invalid.R" file if available 
invalid <- character(0)
setwd(rootdir)
if("invalid.R" %in% list.files()) source("invalid.R")

# Find all symbols not in directory and not missing
setwd(datadir)

toload <- setdiff(S[!paste0(S, ".csv") %in% list.files()], invalid) 


# Fetch symbols with yahoo function, save as .csv or missing
source(paste0(functiondir, "eikon.R"))
histdata <- map(toload, ~eikon_get(.x)) %>% set_names(toload)


savestockdata <-
  function (stockdata, invalid) {
    
    if(!is.null(stockdata)) {
      stockname <- (paste0(stockdata$RIC[1], ".csv"))
      write_csv(stockdata,  stockname)
      
    } else {
      invalid <- c(invalid, stockname)
    }    
  }

map(histdata, ~ savestockdata (.x), invalid)
setwd(rootdir)
dump(list = c("invalid"), "invalid.R")

# source ("D:/repositories/marketdata/config.R")

####  Load Request Builder File Scheduler Response File ####
LoadResponseFile <- 
  function(     FSPath   = file_sechist_path ,
                FSName   = file_sechist_name , 
                FSDate   = "20180130_20210107",
                ColNames = col_sechist,
                ColProp = col_prop_sechist,
                Sep = "|",  
                start_row =30 ) 
    
  {
    dlfile <- paste0(FSPath,"/", FSName, ".",FSDate )
    dlfile_prices <- read_delim(dlfile,
                                delim = Sep, 
                                skip = start_row,   
                                col_types = ColProp,
                                col_names =  ColNames) 
    
    # exclude the last 3 lines, containing comments
    nbonds <- nrow(dlfile_prices)-3
    dlfile_prices  <- head(dlfile_prices, nbonds) 
    tryCatch(suppressWarnings(dlfile_prices), error = function(e) NULL)
  }
####
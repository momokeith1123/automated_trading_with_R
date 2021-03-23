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
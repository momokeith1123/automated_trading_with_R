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
histdata <- map(toload, ~eikon_get(.x))

if( length(seq_along(histdata)) != 0){
  # 
  # for(i in 1:length(toload)){
  for(i in seq_along(histdata) ) {
    print(i)
    df <- histdata[[i]]

    if(!is.null(df)) {
      RIC <- (paste0(histdata[[i]][[8]][1], ".csv"))
      write_csv(df,  RIC)

    } else {
      invalid <- c(invalid, toload[i])
    }
    
  }
}

setwd(rootdir)
dump(list = c("invalid"), "invalid.R")
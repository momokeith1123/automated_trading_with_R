# Listing 2.5

#### Loading Data into Memory ####
setwd(DIR[["data"]]) 
S <- sub(".csv", "", list.files())

library(tidyverse)
library(data.table)

DATA <- list()
for(i in S){
  suppressWarnings(
  DATA[[i]] <- read_csv(paste0(i, ".csv")) ) %>% arrange(DATE)
  # DATA[[i]] <- (DATA[[i]])[order(DATA[[i]][["Date"]], decreasing = FALSE)]
} 
####
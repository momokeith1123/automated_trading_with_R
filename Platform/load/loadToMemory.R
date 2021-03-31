# Listing 2.5

#### Loading Data into Memory ####
setwd(DIR[["data"]]) 
S <- sub(".csv", "", list.files())

library(tidyverse)
library(data.table)

DATA <- list()
for(i in S){
  print (i)
  suppressWarnings(
    DATA[[i]] <- read.table(paste0(i, ".csv"), header = TRUE, sep = ",",stringsAsFactors = FALSE) )
} 
####


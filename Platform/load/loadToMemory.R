# Listing 2.5

#### Loading Data into Memory ####
setwd(DIR[["data"]]) 
S <- sub(".csv", "", list.files())

library(tidyverse)
library(data.table)

DATA <- list()
for(i in S){
  suppressWarnings(
  # DATA[[i]] <- read_csv(paste0(i, ".csv")) ) %>% arrange(Date)
  # DATA[[i]] <- read_delim(paste0(i, ".csv"), delim = ",", col_types = "cccccccc") )
    DATA[[i]] <- read.table(paste0(i, ".csv"), header = TRUE, sep = ",",stringsAsFactors = FALSE))
  # dt = as.Date(StockData$Date, format = "%Y-%m-%d")
  # DATA[[i]] = xts (x = cbind(StockData$Open,StockData$High,StockData$Low, StockData$Close,StockData$Volume), order.by = dt)
  # colnames(DATA[[i]]) <- paste0(i,".",c("Open", "High", "Low", "Close", "Volume"))
} 
####


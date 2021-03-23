# Up-to-date at time of writing (May 2016)
require(tidyverse)
url <- "D:/repositories/automated_trading_with_R/Listings/Chapter 2/SPstocks.csv"
S <- as.character(read.csv(url, header = FALSE)[,2])
N <- as.character(read.csv(url, header = FALSE)[,1])

S <- S %>% set_names(N)
# S <- S %>% set_names(S.names)
# save S.R with stock list from URL
setwd(rootdir)
dump(list = "S", "S.R")
# dump(list = "N", "N.R")

SnpList <- tibble(RIC = S,  names = N)
dump (list = 'SnpList', 'SnpList.R')


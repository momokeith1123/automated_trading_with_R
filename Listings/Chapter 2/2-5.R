# Loading Data inot Memory
setwd(datadir) 
S <- sub(".csv", "", list.files())

require(data.table)

DATA <- list()
for(i in S){
  suppressWarnings(
  DATA[[i]] <- fread(paste0(i, ".csv"), sep = ","))
  DATA[[i]] <- (DATA[[i]])[order(DATA[[i]][["TIMESTAMP"]], decreasing = FALSE)]
} 

# all_files_purrr <- map(S, read_csv) 


getOPEN <-
function (df) {
  stock <- df$RIC[1]
  df <- df %>% select(TIMESTAMP, OPEN) %>% set_names('Dates', stock)
  
  dates <- as.Date(as.character(df[,1]), format = "%Y-%m-%d")
  data  <- df[,-1]
  tsdata <- xts( x = data, order.by = dates)
  
}

#   Transform into xts data
transforn_into_xts <- function (df) {
  dates <- as.Date(as.character(df[,1]), format = "%Y-%m-%d")
  data  <- df[,-1]
  tsdata <- xts( x = data, order.by = dates)
}
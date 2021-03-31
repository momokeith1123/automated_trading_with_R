library(zoo)
library(lubridate)

newDataObject <- function (df , field = "Close")
{
  stock = unique(df$Ric)
  newDataObject <- df[,c("Date",field)]
  names(newDataObject) <- c("Date", stock)
  NDO <- as_tibble(newDataObject)
  
}


# Compute the date template as a column of a data.frame for merging
# Considers date are strings in YYYY-MM-DD format
datetemp <- sort(unique(unlist(sapply(DATA, function(v) v[["Date"]]))))
datetemp <- data.frame(datetemp, stringsAsFactors = FALSE)
names(datetemp) <- "Date"

# Double-check that our data is unique and in ascending-date order
DATA <- lapply(DATA, function(v) unique(v[order(v$Date),]))


# Create 5 new objects that will hold our re-orgainzed data
STOCK <- list()
# DATA[["Close"]] <- lapply (DATA,  newDataObject,  "Close") %>% reduce(left_join)
for (i in c("Open", "High", "Low", "Close","Volume")) {
  STOCK[[i]] <- lapply (DATA,  newDataObject,  i) %>% reduce(left_join)
}


# Double-check that our data is unique and in ascending-date order
DATA <- lapply(STOCK, function(v) unique(v[order(v$Date),]))

# Fill NAs with last oberservation
DATA <- lapply (DATA,  na.locf, fromLast = TRUE)



# Declare them as zoo objects for use with time-series functions
DATA <- lapply(DATA, function(v) xts(x = v[,2:ncol(v)],order.by =  as.Date( DATA[[1]]$Date, format = "%Y-%m-%d")  ))


# Remove extra variables
rm(list = setdiff(ls(), c("DATA", "DIR")))
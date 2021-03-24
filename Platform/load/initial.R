# Listing 2.4

#### Data Acquisition ####
setwd(DIR[["function"]])
source("eikon.R")

setwd(DIR[["root"]])
if("S.R" %in% list.files()) {
  source("S.R")
} else {
  stocksFile <- paste0(DIR[["root"]], "/", "SPric.csv")
  S <- as.character(read.csv( stocksFile, header = FALSE)[,1])
  dump(list = "S", "S.R")
}


# Load "invalid.R" file if available
invalid <- character(0)
if("invalid.R" %in% list.files()) source("invalid.R")

# Find all symbols not in directory and not missing
setwd(DIR[["data"]])
toload <- setdiff(S[!paste0(S, ".csv") %in% list.files()], invalid)

# Fetch symbols with eikon_get function, save as ".csv" or missing
if(length(toload) != 0){
  for (i in seq_along(toload)) {
    df <- eikon_get(toload[i])
    if (!is.null(df)) {
      write_csv(df,  paste0(toload[i], ".csv"))
    } else {
      invalid <- c(invalid, toload[i])
    }
  }
}
setwd(DIR[["root"]])
dump(list = c("invalid"), "invalid.R")

# Clears R environment except for path variable and functions
rm(list = setdiff(ls(), c("CONFIG", "DIR", "eikon_get")))
gc()

####
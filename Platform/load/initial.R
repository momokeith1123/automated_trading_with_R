# Listing 2.4
setwd(DIR[["function"]])
source("eikon.R")

setwd(DIR[["root"]])
if("S.R" %in% list.files()) {
  source("S.R")
} else {
  stocksFile <- paste0(DIR[["data"]], "/", "SPric.csv")
  S <- as.character(read.csv( stocksFile, header = FALSE)[,1])
  dump(list = "S", "S.R")
}

invalid <- character(0)
if("invalid.R" %in% list.files()) source("invalid.R")

setwd(DIR[["data"]])
toload <- setdiff(S[!paste0(S, ".csv") %in% list.files()], invalid)

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

rm(list = setdiff(ls(), c("CONFIG", "DIR", "yahoo")))
gc()


#### 2.6 update method with quandl_get function
# To prove that this works, at this point you might want to delete some rows in
# any of the csv files under stockdata.
# force system time to "EST"
Sys.setenv(TZ="EST")
currentTime <- Sys.time()

for(i in S){
  # Store greatest date within DATA for symbol i
  # maxdate <- max(index(DATA[[i]])[nrow(DATA[[i]])])
 
  print(i)
  maxdate <- ymd(max(DATA[[i]]$DATE [nrow(DATA[[i]])]))
  if(as.numeric(difftime(currentTime, maxdate, units = "hours")) >= 40.25){
    
    # Push the maxdate forward one day
    maxdate <- strptime(maxdate, "%Y-%m-%d") + 86400
    
    weekend <- sum(c("Saturday", "Sunday") %in%
                     weekdays(c(maxdate, currentTime))) == 2
    
    if(!weekend){
      # if !weekend then start_date for quandl = maxdate
      start_date = as.character(maxdate)
      df <- eikon_get(i, sdate = paste0(start_date,"T00:00:00") )
      # colnames(df) <- column_names
      if(!is.null(df)){
        if(all(!is.na(df)) & nrow(df) > 0){
          stockfile <- file(paste0(i, ".csv"), open = "a" )
          # df <- df[nrow(df):1] # not needed, is type = "zoo"
          # write csv file with new data, duplicates might exist
          
          write_delim(df, paste0(i, ".csv"),delim =",", append = TRUE)
          DATA[[i]] <- bind_rows(DATA[[i]], df)
          
          # just in case, sort by index. Remove duplicates?
          DATA[[i]] <- zoo(DATA[[i]], order.by = index(DATA[[i]]))
        }
      }
    }
  }
  
  
}

#### 2.7 method not needed
####
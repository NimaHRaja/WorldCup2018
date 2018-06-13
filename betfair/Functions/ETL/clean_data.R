data_files <- list.files("betfair/data/")

clean_a_data_file <- function(a_data_file){
    
    load(paste("betfair/data/", a_data_file, sep = ""))
    print(a_data_file)
    
    meta_selectionid <- as.data.frame(MarketBook$Catalogue$runners)
    
    price_data <- as.data.frame(MarketBook$MarketBook$runners)
    price_data <- merge(price_data, meta_selectionid, by = "selectionId")
    price_data$back <- unlist(lapply(price_data$ex$availableToBack, function(x) max(x$price)))
    price_data$lay <- unlist(lapply(price_data$ex$availableToLay, function(x) min(x$price)))
    out <- 
        price_data %>% select(c(status, runnerName, back, lay)) %>% filter(status == "ACTIVE")
    
    out$time <- MarketBook$time
    out$marketName <- MarketBook$Catalogue$marketName
    out$eventName <- MarketBook$Catalogue$event$name
    out$totalMatched <- MarketBook$MarketBook$totalMatched
    out$totalAvailable <- MarketBook$MarketBook$totalAvailable
    out$marketStartTime <- MarketBook$Catalogue$marketStartTime
    
    out
}

clean_a_day_of_data <- function(a_date_to_clean){
    files <- list.files("betfair/data/")
    
    file_dates <- 
        unlist(lapply(strsplit(files, "_"), 
                      function(x) {x[grepl("20180", x)]}))
    
    # table(file_dates)
    
    data_files_a_date <- 
        files[file_dates == a_date_to_clean]
    
    a_date_data <- 
        do.call(rbind, lapply(data_files_a_date, clean_a_data_file))
    
    write.csv(a_date_data, 
              paste("betfair/data_cleaned/all_data_", a_date_to_clean, sep = ""), 
              row.names = FALSE)
}
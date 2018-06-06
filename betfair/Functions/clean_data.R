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
    out$totalMatched <- MarketBook$MarketBook$totalMatched
    out$totalAvailable <- MarketBook$MarketBook$totalAvailable
    
    out
}



all_data_odds <- do.call(rbind, lapply(data_files, clean_a_data_file))
write.csv(all_data_odds, "betfair/all_data_odds.csv", row.names = FALSE)

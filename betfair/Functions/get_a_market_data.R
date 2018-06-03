get_a_market_data <- function(a_market_id, folder, market_name){
    
    MarketBook_raw <- 
        listMarketBook(marketIds = a_market_id, 
                       priceData = "EX_ALL_OFFERS")
    
    time <- Sys.time()
    file_name <- paste("betfair/data/",
                       market_name,
                       "_",
                       format(time, "%Y%m%d_%H%M%S"),
                       ".rda", 
                       sep = "")
    
    MarketBook <- 
        list(time = time, 
             market = "Winner",
             MarketBook = MarketBook_raw)
    
    save(MarketBook, file = file_name)
}
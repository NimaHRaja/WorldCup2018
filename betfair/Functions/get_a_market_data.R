get_a_market_data <- function(a_market, folder){

    market_id <- as.data.frame(a_market)$marketId
    market_name <- gsub("/", "-",  as.data.frame(a_market)$marketName)
    
    MarketBook_raw <- 
        listMarketBook(marketIds = market_id, 
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
             Catalogue = a_market,
             MarketBook = MarketBook_raw)
    
    save(MarketBook, file = file_name)
}
# get_and_save_a_market
# this function gets a catalogue (of a market) as argument
# and gets MarketBook for that market
# and saves Catalogue, MarketBook, and time in a file

get_and_save_a_market <- function(a_market, folder){

    market_id <- as.data.frame(a_market)$marketId
    market_name <- gsub("/", "-",  as.data.frame(a_market)$marketName)
    event_name <- gsub("/", "-",  as.data.frame(a_market)$event$name)
    
    MarketBook_raw <- 
        listMarketBook(marketIds = market_id, 
                       priceData = "EX_ALL_OFFERS")
    
    time <- Sys.time()
    
    file_name <- paste("betfair/data/",
                       event_name,
                       "_",
                       market_name,
                       "_",
                       format(time, "%Y%m%d_%H%M%S"),
                       ".rda", 
                       sep = "")
    
    print(file_name)
    
    MarketBook <- 
        list(time = time, 
             Catalogue = a_market,
             MarketBook = MarketBook_raw)
    
    save(MarketBook, file = file_name)
}
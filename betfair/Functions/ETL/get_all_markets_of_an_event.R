# get_all_markets_of_an_event
# finds all markets of an events
# and passes their catalogue to get_and_save_a_market

get_all_markets_of_an_event <- function(eventtypeid, competitionid, eventid){
    market_types <- 
        listMarketTypes(eventTypeIds = eventtypeid, 
                        competitionIds = competitionid, 
                        eventIds = eventid,
                        toDate = "2019-05-30T12:00:00Z")$marketType
    
    for (market_type in market_types){
        Market_Catalogue <- 
            listMarketCatalogue(eventTypeIds = eventtypeid, 
                                competitionIds = competitionid, 
                                toDate = "2019-05-30T12:00:00Z", 
                                eventIds = eventid,
                                marketTypeCodes = market_type)                    
        
        for (i in 1:dim(Market_Catalogue)[1]) {
            print(paste("************",Market_Catalogue[i,]$marketName))
            get_and_save_a_market(Market_Catalogue[i,], "betfair/data/")
        }
    }
}
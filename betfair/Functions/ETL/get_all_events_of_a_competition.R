# get_all_events_of_a_competition
# finds all events of a competition
# and passes their eventids to get_all_markets_of_an_event

get_all_events_of_a_competition <- function(eventtypeid, competitionid){
    
    all_events <- 
        listEvents(eventTypeIds = eventtypeid, 
                   competitionIds = competitionid, 
                   toDate = "2019-05-30T12:00:00Z")
    
    # View(all_events)
    
    for (i in 1:dim(all_events)[1]) {
        print(paste("*******************", all_events$event$name[i], "*******************"))
        get_all_markets_of_an_event(eventtypeid, competitionid, all_events$event$id[i])
    }
}

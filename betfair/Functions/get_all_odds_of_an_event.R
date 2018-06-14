get_all_odds_of_an_event <- function(a_market, an_event, norm_factor){
    
#     data_cleaned_files <- list.files("betfair/data_cleaned/", full.names = TRUE)
#     
#     all_data <- do.call(rbind, 
#                         lapply(
#                             data_cleaned_files, 
#                             read.csv, 
#                             stringsAsFactors = FALSE))
    
    as.data.frame(
        all_data %>% 
            filter(marketName == a_market & eventName == an_event) %>%
            distinct(marketName, eventName, time, runnerName, back, lay) %>%
            mutate(prob = 50/back + 50/lay) %>%
            group_by(marketName, eventName, time) %>%
            mutate(prob = norm_factor * prob / sum(prob)) %>%
            arrange(-prob))
}
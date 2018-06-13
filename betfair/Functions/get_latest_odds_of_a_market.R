get_latest_odds_of_a_market <- function(a_market, norm_factor){
    
    data_cleaned_files <- list.files("betfair/data_cleaned/", full.names = TRUE)
    
    all_data <- do.call(rbind, 
                        lapply(
                            max(data_cleaned_files), 
                            read.csv, 
                            stringsAsFactors = FALSE))
    
    as.data.frame(
        all_data %>% 
            filter(marketName == a_market) %>%
            distinct(eventName, time, runnerName, back, lay) %>%
            group_by(eventName, runnerName) %>%
            filter(time == max(time)) %>%
            mutate(prob = 50/back + 50/lay) %>%
            group_by(eventName) %>%
            mutate(prob = norm_factor * prob / sum(prob)) %>%
            arrange(-prob))
}
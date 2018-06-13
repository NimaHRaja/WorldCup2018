get_an_odds_v_time_graph <- 
    function(a_market, min_prob, min_prob_errorbar_ratio, max_prob_graph, with_line){
    
    all_data_odds <- read.csv("betfair/all_data_odds.csv")
    market_odds <- 
        all_data_odds %>% 
        filter(marketName == a_market) %>%
        mutate(prob = (100/back + 100/lay)/2) %>%
        mutate(errorbar = 100/back - 100/lay) %>%
        filter(prob/errorbar > min_prob_errorbar_ratio) %>%
        filter(prob > min_prob)
    
    out <- 
        ggplot(market_odds,
               aes(x = as.POSIXct(time), y = prob, colour = runnerName)) +
        geom_point() +
        geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
        ylim(0,max_prob_graph) + 
        ggtitle(a_market) +
        xlab("Date")
    
    if(with_line)
        out <- out + geom_line()
    
    out
}
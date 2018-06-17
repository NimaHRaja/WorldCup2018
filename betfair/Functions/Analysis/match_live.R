#to be documented
DF_match_live <- read.csv("betfair/data_Matches/PORESP.csv")

DF_match_live <- 
    DF_match_live %>% 
    filter(marketName == "Match Odds") %>% 
    select(runnerName, back, lay, time, marketName)  %>%
    mutate(prob = 50/back + 50/lay) %>%
    arrange(-prob)

# jpeg("betfair/outputs/twitter_EGYURU_numgoals_20180615_1.jpg", height = 900, width = 1200)
P2 <-
ggplot(DF_match_live, 
       aes(x = as.POSIXct(time), y = prob, colour = runnerName)) + 
    geom_point() + 
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    geom_line() +
    xlab("time") +
    ylim(c(0,100)) + 
    labs(colour = "Match Odds") +
    ggtitle("Betfair / POR v ESP")

# dev.off()
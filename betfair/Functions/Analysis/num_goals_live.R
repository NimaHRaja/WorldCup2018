DF_numgoals_live <- read.csv("betfair/data_Matches/EGYURU.csv")

DF_numgoals_live <- 
    DF_numgoals_live %>% 
    filter(grepl("Over", marketName) & 
               grepl("Over", runnerName) & 
               !grepl("Match", marketName) & 
               !grepl("Egypt", marketName) & 
               !grepl("Uruguay", marketName) &
               !grepl("Half", marketName) & 
               !grepl("Cards", marketName) & 
               !grepl("Corners", marketName)) %>% 
    select(runnerName, back, lay, time, marketName)  %>%
    mutate(prob = 50/back + 50/lay) %>%
    arrange(-prob)

jpeg("betfair/outputs/twitter_EGYURU_numgoals_20180615_1.jpg", height = 900, width = 1200)
ggplot(DF_numgoals_live, 
       aes(x = as.POSIXct(time), y = prob, colour = runnerName)) + 
    geom_point() + 
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    geom_line() +
    xlab("time") +
    ylim(c(0,100)) + 
    labs(colour = "# goals") +
    ggtitle("Betfair / EGY v URU / # goals")
dev.off()
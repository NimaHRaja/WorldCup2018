all_data <- read.csv("betfair/all_data_odds.csv")

DF_market_sizes <- 
    as.data.frame(
        all_data %>% 
            filter(marketName == "Match Odds") %>%
            distinct(eventName, totalMatched, marketStartTime) %>%
            group_by(eventName, marketStartTime) %>%
            filter(totalMatched == max(totalMatched)) %>%
            arrange(marketStartTime)
    )

DF_market_sizes$eventName <- factor(DF_market_sizes$eventName, levels = DF_market_sizes$eventName[order(DF_market_sizes$marketStartTime)])

# jpeg("betfair/outputs/twitter_BetfairMatchesTotalMatched_20180607.jpg", width = 1200, height = 600)
ggplot(DF_market_sizes,
       aes(x = eventName, 
           y = totalMatched, 
           fill = factor(as.integer(format(as.Date(DF_market_sizes$marketStartTime), "%d")) %% 5 + 1)))+
    geom_bar(stat = "identity") + 
    theme(axis.text.x = element_text(angle = -90), legend.position = "none") +
    scale_y_continuous(label = unit_format(unit = "£")) +
    xlab("Match") +
    ggtitle("Betfair / Worldcup 2018 / Match Odds / Total Matched / THU 07-JUN-18")
# dev.off()
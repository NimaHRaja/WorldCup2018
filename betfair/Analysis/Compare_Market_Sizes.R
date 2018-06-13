# Read data

all_data <- read.csv("betfair/all_data_odds.csv")


# filter for Match odds and latest data

DF_market_sizes <- 
    as.data.frame(
        all_data %>% 
            filter(marketName == "Match Odds") %>%
            distinct(eventName, totalMatched, marketStartTime) %>%
            group_by(eventName, marketStartTime) %>%
            filter(totalMatched == max(totalMatched)) %>%
            arrange(marketStartTime)
    )


DF_market_sizes$eventName <- 
    factor(DF_market_sizes$eventName, 
           levels = DF_market_sizes$eventName[order(DF_market_sizes$marketStartTime)])

# Generate and save graph

# file_name <- "betfair/outputs/twitter_BetfairMatchesTotalMatched_20180607.jpg"
# title <- "Betfair / Worldcup 2018 / Match Odds / Total Matched / THU 07-JUN-18"

file_name <- "betfair/outputs/twitter_BetfairMatchesTotalMatched_20180612.jpg"
title <- "Betfair / Worldcup 2018 / Match Odds / Total Matched / TUE 12-JUN-18"

jpeg(file_name, width = 1200, height = 600)
ggplot(DF_market_sizes,
       aes(x = eventName, 
           y = totalMatched, 
           fill = factor(as.integer(format(as.Date(DF_market_sizes$marketStartTime), "%d")) %% 5 + 1)))+
    geom_bar(stat = "identity") + 
    theme(axis.text.x = element_text(angle = -90), legend.position = "none") +
    scale_y_continuous(label = unit_format(unit = "£")) +
    xlab("Match") +
    ggtitle(title)
dev.off()
library(ggplot2)
library(scales)



ggplot(subset(all_data_odds, marketName == "Winner 2018"),
       aes(x = as.POSIXct(time), y = totalMatched)) + 
    geom_point(colour = "blue") +
    # ylim(c(0,  max(subset(all_data_odds, marketName == "Winner 2018")$totalMatched)*1.1)) +
    xlab("time") +
    ylab("Total Matched") + 
    ggtitle("Betfair / Worldcup 2018 / Winner / Total Matched") +
    scale_y_continuous(label = unit_format(unit = "£"), 
                       limits = c(0,  max(subset(all_data_odds, marketName == "Winner 2018")$totalMatched)*1.1))
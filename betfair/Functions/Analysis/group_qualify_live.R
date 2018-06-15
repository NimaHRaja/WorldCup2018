DF <- read.csv("betfair/data_Matches/EGYURU.csv")

Team_colours <- read.csv("betfair/Team_colours.csv", stringsAsFactors = FALSE)

DF <- 
    DF %>% 
    filter(marketName == "To Qualify" & eventName == "Group A") %>%
    mutate(prob = 50/back + 50/lay)


DF <- 
    merge(DF, 
          Team_colours, 
          by.x = "runnerName",
          by.y = "Team")

my_colours <- unique(as.character(DF$Team_colour[order(DF$runnerName)]))

jpeg("betfair/outputs/twitter_GroupA_live_20180615_1.jpg", height = 900, width = 1200)
ggplot(DF, aes(x = as.POSIXct(time), y = prob, colour = runnerName)) + 
    geom_point() +
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    geom_line() +
    scale_colour_manual(values =my_colours) +
    xlab("Date") +
    ylim(c(0,100)) +
    ggtitle("Betfair / Worldcup 2018 / GROUP A / To Qualify / FRI 15-JUN-18") +
    theme_dark() + 
    labs(colour = "Team")
dev.off()
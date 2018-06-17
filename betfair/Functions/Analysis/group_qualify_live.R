#to be documented
DF_qual_live <- read.csv("betfair/data_Matches/PORESP.csv")

Team_colours <- read.csv("betfair/Team_colours.csv", stringsAsFactors = FALSE)

DF_qual_live <- 
    DF_qual_live %>% 
    filter(marketName == "To Qualify" & eventName == "Group B") %>%
    mutate(prob = 50/back + 50/lay)


DF_qual_live <- 
    merge(DF_qual_live, 
          Team_colours, 
          by.x = "runnerName",
          by.y = "Team")

my_colours <- unique(as.character(DF_qual_live$Team_colour[order(DF_qual_live$runnerName)]))

# jpeg("betfair/outputs/twitter_GroupA_live_20180615_2.jpg", height = 900, width = 1200)
P1 <- 
ggplot(DF_qual_live, aes(x = as.POSIXct(time), y = prob, colour = runnerName)) + 
    geom_point() +
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    geom_line() +
    scale_colour_manual(values =my_colours) +
    xlab("Date") +
    ylim(c(0,100)) +
    ggtitle("Betfair / Worldcup 2018 / GROUP B / To Qualify") +
    theme_dark() + 
    labs(colour = "Team")

# dev.off()

#to be documented
DF_rockbottom_live <- read.csv("betfair/data_Matches/PORESP.csv")

Team_colours <- read.csv("betfair/Team_colours.csv", stringsAsFactors = FALSE)

DF_rockbottom_live <- 
    DF_rockbottom_live %>% 
    filter(marketName == "Rock Bottom" & eventName == "Group B") %>%
    mutate(prob = 50/back + 50/lay)


DF_rockbottom_live <- 
    merge(DF_rockbottom_live, 
          Team_colours, 
          by.x = "runnerName",
          by.y = "Team")

my_colours <- unique(as.character(DF_rockbottom_live$Team_colour[order(DF_rockbottom_live$runnerName)]))

# jpeg("betfair/outputs/twitter_GroupA_live_20180615_2.jpg", height = 900, width = 1200)
P4 <- 
    ggplot(DF_rockbottom_live, aes(x = as.POSIXct(time), y = prob, colour = runnerName)) + 
    geom_point() +
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    geom_line() +
    scale_colour_manual(values =my_colours) +
    xlab("Date") +
    ylim(c(0,100)) +
    ggtitle("Betfair / Worldcup 2018 / GROUP B / Rock Bottom") +
    theme_dark() + 
    labs(colour = "Team")

# dev.off()

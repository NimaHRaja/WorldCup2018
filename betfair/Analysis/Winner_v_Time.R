all_data_odds <- read.csv("betfair/all_data_odds.csv")

a_market <- "Winner 2018"
min_prob <- 5
min_prob_errorbar_ratio <- 0.01
max_prob_graph <- 30

market_odds <- 
    all_data_odds %>% 
    filter(marketName == a_market) %>%
    mutate(prob = (100/back + 100/lay)/2) %>%
    mutate(errorbar = 100/back - 100/lay) %>%
    filter(prob/errorbar > min_prob_errorbar_ratio) %>%
    filter(prob > min_prob)

names(market_odds)[names(market_odds) == "runnerName"] <- "Team"

Team_colours <- 
        data.frame(
            Team = c("Argentina", "Belgium",  "Brazil", "England", "France", "Germany", "Spain"), 
            Team_colour = c("lightblue", "tomato1", "darkgoldenrod1", "gray", "blue", "White", "red1"))

market_odds$Team <- 
    factor(market_odds$Team, levels = unique(market_odds$Team)[order(unique(market_odds$Team))])

my_colours <- 
    unique(Team_colours$Team_colour)[order(unique(Team_colours$Team))]

jpeg("betfair/outputs/twitter_BetfairWinnervTime_20180609.jpg", width = 1200, height = 600)
ggplot(market_odds,
       aes(x = as.POSIXct(time), y = prob, colour = Team)) +
    geom_point() +
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    ylim(0,max_prob_graph) + 
    ggtitle("Betfair / Worldcup 2018 / Winner") +
    xlab("Date") +
    geom_line() +  
    theme_dark() +
    scale_colour_manual(values = my_colours)
dev.off()
#to be documented
source("betfair/Functions/get_latest_odds_of_a_market.R")
source("FiveThirtyEight/get_FiveThirtyEight_predictions.R")
Team_colours <- read.csv("betfair/Team_colours.csv", stringsAsFactors = FALSE)

predictions_538 <- predictions_538 %>% filter(Group == "B")
DF_qual_prob <- get_latest_odds_of_a_market("To Qualify", 200)


DF_qual_prob <- merge(predictions_538,
                      DF_qual_prob,
                      by.x = "Team", 
                      by.y = "runnerName")

names(DF_qual_prob)[names(DF_qual_prob) == " MakeRound of 16MakeRd. of 16"] <- "prob_FiveThirtyEight"
names(DF_qual_prob)[names(DF_qual_prob) == "prob"] <- "prob_betfair"
DF_qual_prob$prob_FiveThirtyEight <- as.numeric(gsub("%", "", DF_qual_prob$prob_FiveThirtyEight))

# sum(DF_qual_prob$prob_betfair)
# sum(DF_qual_prob$prob_FiveThirtyEight)

DF_qual_prob <- 
    merge(DF_qual_prob, 
          Team_colours, 
          by = "Team")


jpeg("betfair/outputs/twitter_CompareProbs_GroupB_20180615.jpg", height = 1000, width = 2000)
ggplot(DF_qual_prob, aes(x = prob_betfair, y =  prob_FiveThirtyEight, colour = Team, label = Team)) + 
    geom_point() + 
    geom_text(size = 5) +
    geom_abline(slope = 1, intercept = 0, colour = "orange") +
    scale_colour_manual(values = DF_qual_prob$Team_colour) +
    theme_dark() +
    theme(legend.position = "none") +
    xlim(c(0,100)) + 
    # scale_x_log10() +
    # scale_y_log10() +
    ylim(c(0,100))
dev.off()

# ggplot(DF_qual_prob, aes(x = prob_betfair, y =  prob_FiveThirtyEight, colour = Group, label = Team)) + 
#     geom_point() + 
#     geom_text() +
#     geom_abline(slope = 1, intercept = 0, colour = "orange") +
#     # theme_dark() +
#     xlim(c(0,100)) +
#     ylim(c(0,100))

####### version 30JUN

load("betfair/data/FIFA World Cup 2018_Winner 2018_20180630_120808.rda")


meta_selectionid <- as.data.frame(MarketBook$Catalogue$runners)
price_data <- as.data.frame(MarketBook$MarketBook$runners)
price_data <- merge(price_data, meta_selectionid, by = "selectionId")
price_data$back <- unlist(lapply(price_data$ex$availableToBack, function(x) max(x$price)))
price_data$lay <- unlist(lapply(price_data$ex$availableToLay, function(x) min(x$price)))
DF_betfair <- 
    price_data %>% 
    select(c(status, runnerName, back, lay)) %>% 
    filter(status == "ACTIVE") %>%
    mutate(prob = 50/back + 50/lay) %>%
    mutate(prob_betfair = 100 * prob / sum(prob)) 

DF_538 <- clean_a_538_html("FiveThirtyEight/Data/FiveThirtyEight_20180630_122100.html")
DF_538$`WinWorld cup` <- gsub("<", "", DF_538$`WinWorld cup`)
DF_538$prob_FiveThirtyEight <-  
    as.numeric(gsub("%", "", DF_538$`WinWorld cup`))

DF_winner_prob <- merge(DF_538,
                        DF_betfair,
                      by.x = "Team", 
                      by.y = "runnerName")

Team_colours <- read.csv("Team_colours.csv", stringsAsFactors = FALSE)

DF_winner_prob <- 
    merge(DF_winner_prob, 
          Team_colours, 
          by = "Team")



jpeg("betfair/outputs/twitter_CompareProbs_Winner_20180630.jpg", height = 1000, width = 2000)
ggplot(DF_winner_prob, aes(x = prob_betfair, y =  prob_FiveThirtyEight, colour = Team, label = Team)) + 
    geom_point() + 
    geom_text(size = 5) +
    geom_abline(slope = 1, intercept = 0, colour = "orange") +
    scale_colour_manual(values = DF_winner_prob$Team_colour) +
    theme_dark() +
    theme(legend.position = "none") +
    xlim(c(0,30)) + 
    # scale_x_log10() +
    # scale_y_log10() +
    ylim(c(0,30))
dev.off()

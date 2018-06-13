source("betfair/Functions/get_latest_odds_of_a_market.R")
source("FiveThirtyEight/get_FiveThirtyEight_predictions.R")
Team_colours <- read.csv("betfair/Team_colours.csv", stringsAsFactors = FALSE)


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


jpeg("betfair/outputs/twitter_CompareProbs_20180613.jpg", height = 1000, width = 2000)
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
#to be documented
original_back <- 1.35
stakes <- 100
folder_name <- "betfair/data_Matches/ARGISL//"
file_name <- "betfair/data_Matches/ARGISL.csv"
team <- "Argentina"
title <- "betfair / World Cup 2018 / ARG v ISL / Cash Out (Back Argentina)"

clean_a_folder(folder_name, file_name)

DF <- read.csv(file_name)

DD <- DF %>% filter(marketName == "Match Odds" & runnerName == team & back > 1)

DD$value_live <- original_back*stakes/DD$lay - stakes

jpeg("betfair/outputs/twitter_ARGISL_CashOut_Argentina_20180616.jpg", height = 800, width = 1200)
ggplot(DD, aes(x = as.POSIXct(time), y = value_live)) + 
    geom_point(colour = "blue") +
    geom_abline(slope = 0, intercept = -stakes, colour = "red") +
    geom_abline(slope = 0, intercept = (original_back-1) * stakes, colour = "green") +
    ylim(c(-120, 60)) +
    ggtitle(title) +
    xlab("time") +
    ylab("PnL (£)")
dev.off()

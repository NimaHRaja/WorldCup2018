#to be documented
data_cleaned_files <- list.files("betfair/data_cleaned/", full.names = TRUE)

all_data <- do.call(rbind, 
                    lapply(
                        data_cleaned_files, 
                        read.csv, 
                        stringsAsFactors = FALSE))

DF_spain <- rbind(
    get_all_odds_of_an_event("To Reach The Final", "FIFA World Cup 2018", 200),
    get_all_odds_of_an_event("To Reach the Semi Final", "FIFA World Cup 2018", 400),
    get_all_odds_of_an_event("To Reach The Quarter Final", "FIFA World Cup 2018", 800),
    get_all_odds_of_an_event("Group Winner", "FIFA World Cup 2018", 100),
    get_all_odds_of_an_event("Rock Bottom", "FIFA World Cup 2018", 100),
    get_all_odds_of_an_event("To Qualify", "FIFA World Cup 2018", 200),
    get_all_odds_of_an_event("To Reach The Final", "FIFA World Cup 2018 - Outrights", 200),
    get_all_odds_of_an_event("To Reach the Semi Final", "FIFA World Cup 2018 - Outrights", 400),
    get_all_odds_of_an_event("To Reach The Quarter Final", "FIFA World Cup 2018 - Outrights", 800),
    get_all_odds_of_an_event("Group Winner", "FIFA World Cup 2018 - Outrights", 100),
    get_all_odds_of_an_event("Rock Bottom", "FIFA World Cup 2018 - Outrights", 100),
    get_all_odds_of_an_event("To Qualify", "FIFA World Cup 2018 - Outrights", 200),
    get_all_odds_of_an_event("Match Odds", "Iran v Spain", 100),
    get_all_odds_of_an_event("Match Odds", "Portugal v Spain", 100),
    get_all_odds_of_an_event("Match Odds", "Spain v Morocco", 100))

DF_spain <- DF_spain %>% filter(runnerName == "Spain" & time > "2018-06-08")

DF_spain[DF_spain$marketName == "Match Odds",]$marketName <- 
    paste(DF_spain[DF_spain$marketName == "Match Odds",]$eventName, "(Spain wins)", "")


jpeg("betfair/outputs/twitter_Spain_Manager_20180614.jpg", height = 800, width = 1600)
ggplot(DF_spain, aes(x = as.POSIXlt(time), y = prob, colour = marketName)) + 
    geom_point() +
    geom_line() +
    ylim(0,100) +
    xlab("Date") +
    ggtitle("betfair / World Cup 2018 / Spain")
dev.off()
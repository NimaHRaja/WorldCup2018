library(ggplot2)

aa <- list.files("betfair/data_Matches/", full.names = TRUE)
aa <- aa[grepl("Winner 2018_20180702", aa)]




clean_a_winner_file <- function(a_file){
    load(a_file)
    meta_selectionid <- as.data.frame(MarketBook$Catalogue$runners)
    
    price_data <- as.data.frame(MarketBook$MarketBook$runners)
    price_data <- merge(price_data, meta_selectionid, by = "selectionId")
    price_data$back <- unlist(lapply(price_data$ex$availableToBack, function(x) max(x$price)))
    price_data$lay <- unlist(lapply(price_data$ex$availableToLay, function(x) min(x$price)))
    price_data$time <- MarketBook$time
    price_data %>% 
        select(c(status, runnerName, back, lay, time)) %>% 
        filter(status == "ACTIVE") 
}

bb <- do.call(rbind, lapply(aa, clean_a_winner_file))
bb$prob <- (100/bb$back + 100/bb$lay)/2


Team_colours <- read.csv("Team_colours.csv", stringsAsFactors = FALSE)

bb <- 
    merge(Team_colours, 
          bb,
          by.y = "runnerName",
          by.x = "Team")

my_colours <- unique(as.character(bb$Team_colour[order(bb$Team)]))

jpeg("betfair/outputs/twitter_Winner_BELJAP_live.jpg", height = 600, width = 1200)
ggplot(bb, aes(x = time, y = prob, colour = Team)) + 
    geom_point() +
    geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
    geom_line() +
    scale_colour_manual(values =my_colours) +
    xlab("Date") +
    ylab("Winner Probability (%)") +
    ggtitle("Betfair / Worldcup 2018 / Winner / 02JUL18") +
    theme_dark() + 
    labs(colour = "Team")
dev.off()    

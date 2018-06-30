options(stringsAsFactors = FALSE)
library(dplyr)
library(ggplot2)
library(scales)

load("betfair/data/FIFA World Cup 2018_To Reach the Semi Final_20180630_120809.rda")
Team_colours <- read.csv("Team_colours.csv")
SF_brackets <- read.csv("SF_Brackets.csv")

meta_selectionid <- as.data.frame(MarketBook$Catalogue$runners)

price_data <- as.data.frame(MarketBook$MarketBook$runners)
price_data <- merge(price_data, meta_selectionid, by = "selectionId")
price_data$back <- unlist(lapply(price_data$ex$availableToBack, function(x) max(x$price)))
price_data$lay <- unlist(lapply(price_data$ex$availableToLay, function(x) min(x$price)))
DF_Semi <- 
    price_data %>% 
    select(c(status, runnerName, back, lay)) %>% 
    filter(status == "ACTIVE") %>%
    mutate(prob = 50/back + 50/lay)

DF_Semi <- 
    merge(Team_colours,
          DF_Semi, 
          by.y = "runnerName",
          by.x = "Team")

DF_Semi <- 
    merge(DF_Semi,
          SF_brackets, 
          by = "Team")

DF_Semi <- DF_Semi  %>%
    group_by(SF) %>%
    mutate(prob = 100 * prob / sum(prob)) %>%
    arrange(-prob) %>%
    group_by(SF) %>%
    mutate(cs = cumsum(prob)) %>%
    mutate(breaks = cs - prob/2)%>% arrange(-prob)



get_a_bracket_semi_pie_chart <- function(a_SF){
    
    DF_Semi <- DF_Semi %>% filter(SF == a_SF)
    
    DF_Semi$Team <- 
        factor(DF_Semi$Team, levels = DF_Semi$Team[order(DF_Semi$prob)])
    
    DF_Semi$Team_colour <- 
        DF_Semi$Team_colour[order(DF_Semi$prob)]
    
    ggplot(DF_Semi, 
           aes(x = "", 
               y = prob, 
               fill = Team))+
        geom_bar(width = 1, stat = "identity", colour = "black") +
        coord_polar(theta = "y", start = 0) +
        theme(legend.position = "none", 
              axis.title.x = element_blank(),
              axis.title.y = element_blank(),
              plot.title = element_text(hjust = 0.5, size = 20),  
              # text = element_text(angle = -45),
              panel.grid=element_blank())+
        ggtitle(a_SF) +
        scale_y_continuous(
            breaks=DF_Semi$breaks,
            labels=paste(DF_Semi$Team, percent(round(DF_Semi$prob)/100))) +
        scale_fill_manual(values = DF_Semi$Team_colour)
}

SF1 <- get_a_bracket_semi_pie_chart("SF1")
SF2 <- get_a_bracket_semi_pie_chart("SF2")
SF3 <- get_a_bracket_semi_pie_chart("SF3")
SF4 <- get_a_bracket_semi_pie_chart("SF4")


library(gridExtra)

jpeg("betfair/outputs/twitter_SemiQual_20180630.jpg", height = 1000, width = 1000)
grid.arrange(SF1, SF2, SF3, SF4)
dev.off()


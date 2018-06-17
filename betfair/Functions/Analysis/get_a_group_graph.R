#to be documented
data_cleaned_files <- list.files("betfair/data_cleaned/", full.names = TRUE)

all_data <- do.call(rbind, lapply(data_cleaned_files, read.csv, stringsAsFactors = FALSE))

Team_colours <- read.csv("betfair/Team_colours.csv", stringsAsFactors = FALSE)

get_a_group_graph <- function(a_group, a_market, a_title, norm_factor){
    
    DF_qual_prob <- 
        as.data.frame(
            all_data %>% 
                filter(marketName == a_market) %>%
                filter(eventName == a_group) %>%
                mutate(prob = 50/back + 50/lay) %>%
                group_by(eventName, time) %>%
                mutate(prob = norm_factor * prob / sum(prob)) %>%
                arrange(-prob))
    
    DF_qual_prob <- 
        merge(DF_qual_prob, 
              Team_colours, 
              by.x = "runnerName",
              by.y = "Team")
    
    
    my_colours <- unique(as.character(DF_qual_prob$Team_colour[order(DF_qual_prob$runnerName)]))
    
    ggplot(DF_qual_prob, aes(x = as.POSIXct(time), y = prob, colour = runnerName)) + 
        geom_point() +
        geom_line() +
        geom_errorbar(aes(ymin=100/lay, ymax=100/back)) +
        scale_colour_manual(values =my_colours) +
        xlab("Date") +
        ylim(c(0,100)) +
        ggtitle(a_title) +
        theme_dark() + labs(colour = "Team")
    
}



plot_Winner <- get_a_group_graph("Group B", 
                                 "Group Winner", 
                                 "Betfair / Worldcup 2018 / Group Winner / FRI 15-JUN-18", 
                                 100)

plot_Qual <- get_a_group_graph("Group B", 
                               "To Qualify", 
                               "Betfair / Worldcup 2018 / To Qualify / FRI 15-JUN-18", 
                               200)

plot_Bottom <- get_a_group_graph("Group B", 
                                 "Rock Bottom", 
                                 "Betfair / Worldcup 2018 / Rock Bottom / FRI 15-JUN-18", 
                                 100)

library(gridExtra)

# jpeg("betfair/outputs/twitter_GroupB_20180615_2.jpg", height = 1000, width = 2000)
grid.arrange(plot_Winner,plot_Qual, plot_Bottom,
             nrow = 2)
# dev.off()


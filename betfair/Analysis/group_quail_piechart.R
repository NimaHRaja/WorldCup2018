all_data_odds <- read.csv("betfair/all_data_odds.csv", stringsAsFactors = FALSE)

Team_colours <- read.csv("betfair/Team_colours.csv")

DF_qual_prob <- 
    as.data.frame(
        all_data_odds %>% 
            filter(marketName == "To Qualify") %>%
            distinct(eventName, time, runnerName, back, lay) %>%
            group_by(eventName, runnerName) %>%
            filter(time == max(time)) %>%
            mutate(prob = 50/back + 50/lay) %>%
            group_by(eventName) %>%
            mutate(prob = 200 * prob / sum(prob)) %>%
            arrange(-prob) %>%
            group_by(eventName) %>%
            mutate(cs = cumsum(prob)) %>%
            mutate(breaks = cs - prob/2))

DF_qual_prob <- 
    merge(DF_qual_prob, 
          Team_colours, 
          by.x = "runnerName",
          by.y = "Team")


get_a_group_qual_pie_chart <- function(a_group){
    
    DF_group <- DF_qual_prob %>% filter(eventName == a_group)

    DF_group$Team <- 
        factor(DF_group$runnerName, levels = DF_group$runnerName[order(DF_group$prob)])
    
    DF_group$Team_colour <- 
        DF_group$Team_colour[order(DF_group$prob)]

    ggplot(DF_group, 
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
        ggtitle(a_group) +
        scale_y_continuous(
            breaks=DF_group$breaks,
            labels=paste(DF_group$Team, percent(round(DF_group$prob)/100))) +
        scale_fill_manual(values = DF_group$Team_colour)
}


plot_A <- get_a_group_qual_pie_chart("Group A")
plot_B <- get_a_group_qual_pie_chart("Group B")
plot_C <- get_a_group_qual_pie_chart("Group C")
plot_D <- get_a_group_qual_pie_chart("Group D")
plot_E <- get_a_group_qual_pie_chart("Group E")
plot_F <- get_a_group_qual_pie_chart("Group F")
plot_G <- get_a_group_qual_pie_chart("Group G")
plot_H <- get_a_group_qual_pie_chart("Group H")

library(gridExtra)

jpeg("betfair/outputs/twitter_GroupQualPie_20180611.jpg", height = 1000, width = 2000)
grid.arrange(plot_A, plot_B, plot_C, plot_D, plot_E, plot_F, plot_G, plot_H, 
             nrow = 2)
dev.off()

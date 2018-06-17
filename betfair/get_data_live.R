# to be documented

# get a match data

for (i in (1:40)){
    Sys.sleep(40)
    get_all_markets_of_an_event(1, 5614746, 28500615, "betfair/data_Matches/CRONIG/")
    get_all_markets_of_an_event(1, 5614746, 27232418, "betfair/data_Matches/CRONIG/")
    get_all_markets_of_an_event(1, 5614746, 28494886, "betfair/data_Matches/CRONIG/")
    print(i)
}

clean_a_folder("betfair/data_Matches/CRONIG/", "betfair/data_Matches/CRONIG.csv")

library(gridExtra)

source("betfair/Functions/Analysis/num_goals_live.R")
source("betfair/Functions/Analysis/group_qualify_live.R")
source("betfair/Functions/Analysis/match_live.R")
source("betfair/Functions/Analysis/group_winner_live.R")

# jpeg("betfair/outputs/twitter_GroupB_live_20180615_4.jpg", height = 1000, width = 2000)
grid.arrange(P1,P3,P2,P4,nrow = 2)
# dev.off()
# 
# 
# jpeg("betfair/outputs/twitter_CRONIG_20180615_1.jpg", height = 900, width = 1200)
# P2
# dev.off()

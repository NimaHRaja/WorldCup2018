# to be documented
# get_data
# connects to betfair API
# and calls get_all_events_of_a_competition 
# which calls get_all_markets_of_an_event
# which calls get_and_save_a_market 
# which saves an event's data


# libraries

library(abettor)
library(dplyr)
library(ggplot2)
library(scales)
library(reshape2)


# login

nima <- read.csv("betfair/my_login_data.csv")

loginBF(username = nima$username, 
        password = nima$password, 
        applicationKey = as.character(nima$applicationKey))


# load functions

source("betfair/Functions/ETL/get_and_save_a_market.R")
source("betfair/Functions/ETL/get_all_markets_of_an_event.R")
source("betfair/Functions/ETL/get_all_events_of_a_competition.R")
# source("betfair/Functions/ETL/clean_data.R")

# get all data

get_all_events_of_a_competition(1, 5614746, "betfair/data/")

# clean_a_day_of_data("20180616")

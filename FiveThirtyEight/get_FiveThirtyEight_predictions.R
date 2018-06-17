# To be documented

library(XML)

# html_538 <- readLines("FiveThirtyEight/Data/FiveThirtyEight_20180613_170230.html")
html_538 <- readLines("FiveThirtyEight/Data/FiveThirtyEight_20180615_150330.html")
predictions_538 <- readHTMLTable(html_538)[[1]]

predictions_538$Team <- gsub(pattern = " 0 pts.", replacement = "", predictions_538$Team)
predictions_538$Team <- gsub(pattern = " 3 pts.", replacement = "", predictions_538$Team)

library(XML)

html_538 <- readLines("FiveThirtyEight/Data/FiveThirtyEight_20180613_170230.html")
predictions_538 <- readHTMLTable(html_538)[[1]]

predictions_538$Team <- gsub(pattern = " 0 pts.", replacement = "", predictions_538$Team)

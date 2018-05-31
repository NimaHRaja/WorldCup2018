---
title: "find_betfair_worldcup2018_markets"
author: "Nima Hamedani-Raja"
date: "29 May 2018"
output: 
  html_document: 
    keep_md: yes
---

## About 

A piece of code to find the IDs of betfair World Cup markets. I'll use these IDs to regularly sample the market.  
I am using [abettor](https://github.com/phillc73/abettor) here. Many thanks to [phillc73](https://github.com/phillc73).  
also see [betfair developer program](http://docs.developer.betfair.com/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started).  

## INIT

Install and load abettor.


```r
# devtools::install_github("phillc73/abettor")
library("abettor")
```

load other libraries.


```r
library(knitr)
```

```
## Warning: package 'knitr' was built under R version 3.4.4
```


Load username, password, and application key. *as if I am uploading them to a public repo!*


```r
nima <- read.csv("my_login_data.csv")

logoutBF(suppress = TRUE, sslVerify = TRUE)
```

```
## [1] "FAIL:INPUT_VALIDATION_ERROR"
```

```r
loginBF(username = nima$username, 
        password = nima$password, 
        applicationKey = as.character(nima$applicationKey))
```

```
## [1] "SUCCESS:"
```

Find eventtype.id for football:  


```r
eventtypes <- listEventTypes()

eventtypes
```

```
##    eventType.id   eventType.name marketCount
## 1             1           Soccer        2406
## 2          7522       Basketball          75
## 3             2           Tennis        2185
## 4             3             Golf          16
## 5             4          Cricket         123
## 6          1477     Rugby League          23
## 7             5      Rugby Union           9
## 8             7     Horse Racing         773
## 9      27454571          Esports          28
## 10           10     Special Bets           2
## 11       998917       Volleyball          14
## 12        61420 Australian Rules          17
## 13       468328         Handball          45
## 14         3503            Darts          52
## 15         4339 Greyhound Racing         293
## 16         7511         Baseball          33
## 17         6231   Financial Bets           2
```

```r
football_eventtypeid <- subset(eventtypes$eventType, name == "Soccer")$id

football_eventtypeid
```

```
## [1] "1"
```

List all football competitions. Make sure toDate is set to a date *after* the final match, default value is tomorrow.    


```r
football_competitions <- 
    listCompetitions(eventTypeIds = football_eventtypeid, 
                     toDate = "2019-05-30T12:00:00Z")

head(football_competitions)
```

```
##   competition.id         competition.name marketCount competitionRegion
## 1         892425             Czech 3 Liga         200               CZE
## 2             13        Brazilian Serie A         436               BRA
## 3        7710075          Polish III Liga         150               POL
## 4        5281887         Finnish Kolmonen          25               FIN
## 5         311575 Hungarian U19 Division 1         100               HUN
## 6         920858     Norwegian 3 Division         200               NOR
```

```r
worldcup_competitionid <- 
    subset(football_competitions$competition, 
           name == "2018 FIFA World Cup")$id

worldcup_competitionid
```

```
## [1] "5614746"
```

List MarketTypes:  


```r
listMarketTypes(eventTypeIds = football_eventtypeid, 
                competitionIds = worldcup_competitionid, 
                toDate = "2019-05-30T12:00:00Z")
```

```
##             marketType marketCount
## 1               WINNER           1
## 2       TO_REACH_SEMIS           1
## 3       TOP_GOALSCORER           2
## 4     UNDIFFERENTIATED          19
## 5    TO_REACH_QUARTERS           1
## 6              SPECIAL          13
## 7       TO_REACH_FINAL           1
## 8          ROCK_BOTTOM           6
## 9      ALT_TOTAL_GOALS          48
## 10     HALF_TIME_SCORE          31
## 11                ACCA           1
## 12       OVER_UNDER_05          32
## 13       OVER_UNDER_45          32
## 14       OVER_UNDER_65          32
## 15       OVER_UNDER_55          32
## 16          MATCH_ODDS          48
## 17      ASIAN_HANDICAP          48
## 18 BOTH_TEAMS_TO_SCORE          31
## 19           HALF_TIME          31
## 20 HALF_TIME_FULL_TIME          31
## 21       CORRECT_SCORE          32
## 22       OVER_UNDER_15          32
## 23       OVER_UNDER_25          48
## 24       OVER_UNDER_35          32
## 25        BOOKING_ODDS           1
```

For now, I am only interested in WINNER. 

Get MarketCatalogue:  


```r
Winner_MarketCatalogue <- 
    listMarketCatalogue(eventTypeIds = football_eventtypeid, 
                        competitionIds = worldcup_competitionid, 
                        toDate = "2019-05-30T12:00:00Z", 
                        marketTypeCodes = "WINNER")

Winner_MarketCatalogue
```

```
##      marketId  marketName          marketStartTime totalMatched
## 1 1.114597310 Winner 2018 2018-06-08T16:00:00.000Z      3287709
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       runners
## 1 1408, 18, 22, 24, 55212, 29578, 27, 19, 15298, 8212, 15299, 25907, 8207, 32, 37944, 15293, 75105, 25912, 49844, 15301, 412319, 64983, 231372, 15296, 29636, 47966, 75103, 43376, 47965, 51092, 15292, 520320, 15303, 26, 2345367, 447, 61463, 29581, 54600, 29632, 30, 7282, 51090, 15294, 124709, 15288, 61448, 920033, 231787, 49387, 15300, 352, 75108, 15287, 231384, 29, 133244, 75104, 43666, 234794, Brazil, Germany, Spain, France, Argentina, Belgium, England, Portugal, Uruguay, Croatia, Colombia, Russia, Poland, Denmark, Mexico, Switzerland, Egypt, Sweden, Nigeria, Peru, Serbia, Senegal, Iceland, Australia, Japan, Iran, Morocco, Costa Rica, South Korea, Saudi Arabia, Tunisia, Panama, Ecuador, Romania, Montenegro, Scotland, Austria, Czech Republic, Algeria, Bulgaria, Norway, Cameroon, Uzbekistan, Turkey, Wales, Slovakia, Ukraine, Syria, Netherlands, Bosnia, Chile, USA, Ghana, Greece, Northern Ireland, Italy, Rep of Ireland, Ivory Coast, Honduras, New Zealand, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 1408, 18, 22, 24, 55212, 29578, 27, 19, 15298, 8212, 15299, 25907, 8207, 32, 37944, 15293, 75105, 25912, 49844, 15301, 412319, 64983, 231372, 15296, 29636, 47966, 75103, 43376, 47965, 51092, 15292, 520320, 15303, 26, 2345367, 447, 61463, 29581, 54600, 29632, 30, 7282, 51090, 15294, 124709, 15288, 61448, 920033, 231787, 49387, 15300, 352, 75108, 15287, 231384, 29, 133244, 75104, 43666, 234794
##   eventType.id eventType.name competition.id    competition.name event.id
## 1            1         Soccer        5614746 2018 FIFA World Cup 27232418
##            event.name event.timezone           event.openDate
## 1 FIFA World Cup 2018  Europe/London 2018-06-14T15:00:00.000Z
```

```r
Winner_marketId <- 
    Winner_MarketCatalogue$marketId

Winner_marketId
```

```
## [1] "1.114597310"
```


```r
Winner_MarketBook <- listMarketBook(marketIds = Winner_marketId, priceData = "EX_ALL_OFFERS")
Winner_MarketBook$runners 
```

```
## [[1]]
##    selectionId handicap status lastPriceTraded totalMatched
## 1         1408        0 ACTIVE             5.7            0
## 2           18        0 ACTIVE             5.9            0
## 3           22        0 ACTIVE             7.4            0
## 4           24        0 ACTIVE             8.0            0
## 5        55212        0 ACTIVE            11.5            0
## 6        29578        0 ACTIVE            12.5            0
## 7           27        0 ACTIVE            19.0            0
## 8           19        0 ACTIVE            32.0            0
## 9        15298        0 ACTIVE            32.0            0
## 10        8212        0 ACTIVE            36.0            0
## 11       15299        0 ACTIVE            50.0            0
## 12       25907        0 ACTIVE            60.0            0
## 13        8207        0 ACTIVE            85.0            0
## 14          32        0 ACTIVE           120.0            0
## 15       37944        0 ACTIVE           150.0            0
## 16       15293        0 ACTIVE           160.0            0
## 17       75105        0 ACTIVE           280.0            0
## 18       25912        0 ACTIVE           280.0            0
## 19       49844        0 ACTIVE           320.0            0
## 20       15301        0 ACTIVE           190.0            0
## 21      412319        0 ACTIVE           250.0            0
## 22       64983        0 ACTIVE           300.0            0
## 23      231372        0 ACTIVE           390.0            0
## 24       15296        0 ACTIVE           810.0            0
## 25       29636        0 ACTIVE           590.0            0
## 26       47966        0 ACTIVE           800.0            0
## 27       75103        0 ACTIVE           620.0            0
## 28       43376        0 ACTIVE           860.0            0
## 29       47965        0 ACTIVE           850.0            0
## 30       51092        0 ACTIVE          1000.0            0
## 31       15292        0 ACTIVE          1000.0            0
## 32      520320        0 ACTIVE          1000.0            0
## 33       15303        0  LOSER              NA           NA
## 34          26        0  LOSER              NA           NA
## 35     2345367        0  LOSER              NA           NA
## 36         447        0  LOSER              NA           NA
## 37       61463        0  LOSER              NA           NA
## 38       29581        0  LOSER              NA           NA
## 39       54600        0  LOSER              NA           NA
## 40       29632        0  LOSER              NA           NA
## 41          30        0  LOSER              NA           NA
## 42        7282        0  LOSER              NA           NA
## 43       51090        0  LOSER              NA           NA
## 44       15294        0  LOSER              NA           NA
## 45      124709        0  LOSER              NA           NA
## 46       15288        0  LOSER              NA           NA
## 47       61448        0  LOSER              NA           NA
## 48      920033        0  LOSER              NA           NA
## 49      231787        0  LOSER              NA           NA
## 50       49387        0  LOSER              NA           NA
## 51       15300        0  LOSER              NA           NA
## 52         352        0  LOSER              NA           NA
## 53       75108        0  LOSER              NA           NA
## 54       15287        0  LOSER              NA           NA
## 55      231384        0  LOSER              NA           NA
## 56          29        0  LOSER              NA           NA
## 57      133244        0  LOSER              NA           NA
## 58       75104        0  LOSER              NA           NA
## 59       43666        0  LOSER              NA           NA
## 60      234794        0  LOSER              NA           NA
##                                   ex.availableToBack
## 1     5.60, 5.50, 5.40, 69305.66, 35934.83, 13464.53
## 2     5.80, 5.70, 5.60, 73290.01, 51079.00, 28293.10
## 3      7.40, 7.20, 7.00, 63581.45, 19547.13, 1901.30
## 4      8.00, 7.80, 7.60, 35998.65, 36031.80, 8783.31
## 5    11.50, 11.00, 10.50, 43456.41, 6919.91, 7501.56
## 6     12.50, 12.00, 11.50, 38717.53, 6325.20, 769.33
## 7    19.00, 18.50, 18.00, 36086.68, 5116.75, 2617.79
## 8    30.00, 29.00, 28.00, 21205.93, 1643.00, 2398.79
## 9    32.00, 30.00, 29.00, 16365.43, 5285.25, 1697.62
## 10   36.00, 34.00, 32.00, 11756.70, 4217.66, 2290.16
## 11     50.00, 48.00, 46.00, 21418.17, 154.74, 152.61
## 12    60.00, 55.00, 50.00, 6491.28, 5604.95, 5084.77
## 13     85.00, 80.00, 75.00, 4960.87, 4525.68, 848.94
## 14 120.00, 110.00, 100.00, 3831.90, 1554.08, 1280.21
## 15   150.00, 140.00, 130.00, 498.28, 3041.23, 836.06
## 16  160.00, 150.00, 140.00, 2384.92, 2017.37, 816.45
## 17     280.00, 270.00, 260.00, 194.76, 100.21, 45.62
## 18    260.00, 250.00, 240.00, 127.10, 616.32, 660.80
## 19    320.00, 310.00, 300.00, 133.88, 411.42, 863.35
## 20      190.00, 180.00, 160.00, 22.98, 83.78, 450.45
## 21      240.00, 210.00, 170.00, 321.75, 31.78, 19.50
## 22      300.00, 280.00, 270.00, 348.67, 12.59, 29.52
## 23     390.00, 380.00, 370.00, 167.42, 122.03, 90.16
## 24       810.00, 800.00, 760.00, 38.98, 23.75, 76.38
## 25      560.00, 550.00, 540.00, 76.18, 139.66, 52.30
## 26      800.00, 790.00, 780.00, 37.04, 15.15, 314.98
## 27       610.00, 600.00, 520.00, 11.00, 41.03, 11.66
## 28       860.00, 850.00, 840.00, 20.74, 50.81, 85.00
## 29     840.00, 830.00, 820.00, 108.25, 128.47, 16.15
## 30  1000.00, 100.00, 2.00, 1439.07, 24.42, 100000.00
## 31     1000.00, 830.00, 160.00, 769.22, 11.48, 21.66
## 32         1000.0, 650.0, 120.0, 1331.3, 146.0, 19.1
## 33                                              NULL
## 34                                              NULL
## 35                                              NULL
## 36                                              NULL
## 37                                              NULL
## 38                                              NULL
## 39                                              NULL
## 40                                              NULL
## 41                                              NULL
## 42                                              NULL
## 43                                              NULL
## 44                                              NULL
## 45                                              NULL
## 46                                              NULL
## 47                                              NULL
## 48                                              NULL
## 49                                              NULL
## 50                                              NULL
## 51                                              NULL
## 52                                              NULL
## 53                                              NULL
## 54                                              NULL
## 55                                              NULL
## 56                                              NULL
## 57                                              NULL
## 58                                              NULL
## 59                                              NULL
## 60                                              NULL
##                                   ex.availableToLay ex.tradedVolume
## 1     5.70, 5.80, 5.90, 11290.89, 12985.00, 5255.34            NULL
## 2    5.90, 6.00, 6.20, 21439.24, 12123.25, 15779.30            NULL
## 3     7.60, 7.80, 8.00, 17639.21, 22902.71, 3279.74            NULL
## 4      8.20, 8.40, 8.60, 21003.43, 11358.96, 242.35            NULL
## 5  12.00, 12.50, 13.00, 32925.22, 13336.72, 2713.89            NULL
## 6   13.00, 13.50, 14.00, 22552.46, 18041.79, 986.97            NULL
## 7  19.50, 20.00, 21.00, 14293.93, 6658.99, 15010.65            NULL
## 8    32.00, 34.00, 36.00, 20921.98, 7970.93, 427.32            NULL
## 9   34.00, 36.00, 38.00, 15281.28, 5124.51, 1753.18            NULL
## 10    38.00, 40.00, 42.00, 9728.66, 5749.32, 834.51            NULL
## 11   55.00, 60.00, 65.00, 13224.23, 3654.92, 140.84            NULL
## 12     65.00, 70.00, 75.00, 4325.92, 2351.75, 10.00            NULL
## 13     90.00, 95.00, 100.00, 782.07, 1118.57, 46.91            NULL
## 14  130.00, 140.00, 160.00, 1957.00, 1014.00, 23.12            NULL
## 15    160.00, 170.00, 180.00, 605.70, 151.38, 47.47            NULL
## 16    170.00, 180.00, 190.00, 673.42, 648.71, 24.59            NULL
## 17      300.00, 310.00, 330.00, 11.67, 32.35, 12.00            NULL
## 18      280.00, 290.00, 450.00, 27.09, 52.74, 33.44            NULL
## 19     330.00, 340.00, 350.00, 99.45, 52.12, 104.41            NULL
## 20    210.00, 220.00, 260.00, 140.00, 108.86, 22.00            NULL
## 21    260.00, 270.00, 280.00, 490.85, 76.26, 184.10            NULL
## 22      310.00, 320.00, 330.00, 24.67, 91.23, 19.67            NULL
## 23     410.00, 420.00, 430.00, 120.21, 10.15, 26.35            NULL
## 24     830.00, 840.00, 1000.00, 42.53, 12.95, 10.34            NULL
## 25      600.00, 610.00, 840.00, 20.36, 10.85, 17.36            NULL
## 26      830.00, 840.00, 970.00, 39.67, 54.05, 14.13            NULL
## 27      700.00, 710.00, 720.00, 22.78, 45.58, 40.69            NULL
## 28      880.00, 890.00, 940.00, 99.16, 33.00, 15.71            NULL
## 29      860.00, 870.00, 880.00, 14.87, 46.11, 50.00            NULL
## 30                                             NULL            NULL
## 31                                             NULL            NULL
## 32                                             NULL            NULL
## 33                                             NULL            NULL
## 34                                             NULL            NULL
## 35                                             NULL            NULL
## 36                                             NULL            NULL
## 37                                             NULL            NULL
## 38                                             NULL            NULL
## 39                                             NULL            NULL
## 40                                             NULL            NULL
## 41                                             NULL            NULL
## 42                                             NULL            NULL
## 43                                             NULL            NULL
## 44                                             NULL            NULL
## 45                                             NULL            NULL
## 46                                             NULL            NULL
## 47                                             NULL            NULL
## 48                                             NULL            NULL
## 49                                             NULL            NULL
## 50                                             NULL            NULL
## 51                                             NULL            NULL
## 52                                             NULL            NULL
## 53                                             NULL            NULL
## 54                                             NULL            NULL
## 55                                             NULL            NULL
## 56                                             NULL            NULL
## 57                                             NULL            NULL
## 58                                             NULL            NULL
## 59                                             NULL            NULL
## 60                                             NULL            NULL
```




## Temp



```r
# listEvents(eventTypeIds = 1, competitionIds = 5614746, toDate = "2019-05-30T12:00:00Z")
# listEvents(eventTypeIds = 1, competitionIds = 5614746, eventIds = 27232418,  toDate = "2019-05-30T12:00:00Z")
# 
# listMarketCatalogue(eventTypeIds = 1, competitionIds = 5614746, toDate = "2019-05-30T12:00:00Z", 
#                     eventIds = 27232418,
#                     marketTypeCodes =
#                         listMarketTypes(eventTypeIds = 1, competitionIds = 5614746, toDate = "2019-05-30T12:00:00Z")$marketType
# )                    




logoutBF(suppress = TRUE, sslVerify = TRUE)
```

```
## [1] "SUCCESS:"
```

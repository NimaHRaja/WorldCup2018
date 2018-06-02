---
title: "find_betfair_worldcup2018_markets"
author: "Nima Hamedani-Raja"
date: "29 May 2018"
output: 
  html_document: 
    keep_md: yes
---

## About 

A piece of (exploratory) code to find the IDs of betfair World Cup markets. I'll use these IDs to regularly sample the market.  
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
## [1] "SUCCESS:"
```

```r
loginBF(username = nima$username, 
        password = nima$password, 
        applicationKey = as.character(nima$applicationKey))
```

```
## [1] "SUCCESS:"
```

## Odds for a given market  

Find eventtype.id for football:  


```r
eventtypes <- listEventTypes()

eventtypes
```

```
##    eventType.id   eventType.name marketCount
## 1             1           Soccer        7772
## 2             2           Tennis        2836
## 3          7522       Basketball          37
## 4             3             Golf          18
## 5          7524       Ice Hockey           6
## 6             4          Cricket          65
## 7             5      Rugby Union          37
## 8          1477     Rugby League          17
## 9             7     Horse Racing         871
## 10            8      Motor Sport           9
## 11     27454571          Esports          59
## 12       998917       Volleyball          34
## 13           11          Cycling           4
## 14        61420 Australian Rules          47
## 15       468328         Handball          51
## 16         3503            Darts          16
## 17      2152880     Gaelic Games          20
## 18         4339 Greyhound Racing         566
## 19         7511         Baseball          45
## 20       606611          Netball           2
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
##   competition.id     competition.name marketCount competitionRegion
## 1       11804597 Faroe Premier League          25               FRO
## 2         892425         Czech 3 Liga          50               CZE
## 3             13    Brazilian Serie A         380               BRA
## 4        7710075      Polish III Liga         250               POL
## 5        5281887     Finnish Kolmonen          25               FIN
## 6         920858 Norwegian 3 Division         275               NOR
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
all_MarketTypes <- 
    listMarketTypes(eventTypeIds = football_eventtypeid, 
                    competitionIds = worldcup_competitionid, 
                    toDate = "2019-05-30T12:00:00Z")
all_MarketTypes
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
## 1 1.114597310 Winner 2018 2018-06-08T16:00:00.000Z      3494694
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       runners
## 1 1408, 18, 22, 24, 55212, 29578, 27, 19, 15298, 8212, 15299, 25907, 8207, 32, 37944, 15293, 15301, 412319, 25912, 75105, 64983, 49844, 231372, 29636, 75103, 47966, 15296, 47965, 43376, 51092, 15292, 520320, 15303, 26, 2345367, 447, 61463, 29581, 54600, 29632, 30, 7282, 51090, 15294, 124709, 15288, 61448, 920033, 231787, 49387, 15300, 352, 75108, 15287, 231384, 29, 133244, 75104, 43666, 234794, Brazil, Germany, Spain, France, Argentina, Belgium, England, Portugal, Uruguay, Croatia, Colombia, Russia, Poland, Denmark, Mexico, Switzerland, Peru, Serbia, Sweden, Egypt, Senegal, Nigeria, Iceland, Japan, Morocco, Iran, Australia, South Korea, Costa Rica, Saudi Arabia, Tunisia, Panama, Ecuador, Romania, Montenegro, Scotland, Austria, Czech Republic, Algeria, Bulgaria, Norway, Cameroon, Uzbekistan, Turkey, Wales, Slovakia, Ukraine, Syria, Netherlands, Bosnia, Chile, USA, Ghana, Greece, Northern Ireland, Italy, Rep of Ireland, Ivory Coast, Honduras, New Zealand, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 1408, 18, 22, 24, 55212, 29578, 27, 19, 15298, 8212, 15299, 25907, 8207, 32, 37944, 15293, 15301, 412319, 25912, 75105, 64983, 49844, 231372, 29636, 75103, 47966, 15296, 47965, 43376, 51092, 15292, 520320, 15303, 26, 2345367, 447, 61463, 29581, 54600, 29632, 30, 7282, 51090, 15294, 124709, 15288, 61448, 920033, 231787, 49387, 15300, 352, 75108, 15287, 231384, 29, 133244, 75104, 43666, 234794
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

Get the odds: 


```r
Winner_MarketBook <- listMarketBook(marketIds = Winner_marketId, priceData = "EX_ALL_OFFERS")
Winner_MarketBook$runners 
```

```
## [[1]]
##    selectionId handicap status lastPriceTraded totalMatched
## 1         1408        0 ACTIVE             5.7            0
## 2           18        0 ACTIVE             5.8            0
## 3           22        0 ACTIVE             7.4            0
## 4           24        0 ACTIVE             8.0            0
## 5        55212        0 ACTIVE            11.5            0
## 6        29578        0 ACTIVE            12.5            0
## 7           27        0 ACTIVE            19.0            0
## 8           19        0 ACTIVE            30.0            0
## 9        15298        0 ACTIVE            32.0            0
## 10        8212        0 ACTIVE            36.0            0
## 11       15299        0 ACTIVE            50.0            0
## 12       25907        0 ACTIVE            65.0            0
## 13        8207        0 ACTIVE            90.0            0
## 14          32        0 ACTIVE           120.0            0
## 15       37944        0 ACTIVE           150.0            0
## 16       15293        0 ACTIVE           160.0            0
## 17       15301        0 ACTIVE           240.0            0
## 18      412319        0 ACTIVE           240.0            0
## 19       25912        0 ACTIVE           270.0            0
## 20       75105        0 ACTIVE           300.0            0
## 21       64983        0 ACTIVE           310.0            0
## 22       49844        0 ACTIVE           320.0            0
## 23      231372        0 ACTIVE           400.0            0
## 24       29636        0 ACTIVE           610.0            0
## 25       75103        0 ACTIVE           610.0            0
## 26       47966        0 ACTIVE           820.0            0
## 27       15296        0 ACTIVE           720.0            0
## 28       47965        0 ACTIVE           840.0            0
## 29       43376        0 ACTIVE           870.0            0
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
##                                  ex.availableToBack
## 1    5.60, 5.50, 5.40, 62449.53, 33929.08, 13460.46
## 2    5.80, 5.70, 5.60, 69752.23, 51122.79, 28293.36
## 3     7.40, 7.20, 7.00, 71569.99, 10612.79, 1900.49
## 4     8.00, 7.80, 7.60, 23578.37, 35558.04, 9792.85
## 5  11.50, 11.00, 10.50, 42747.91, 18653.98, 7497.34
## 6    12.50, 12.00, 11.50, 45617.88, 7368.36, 770.92
## 7  19.00, 18.50, 18.00, 31036.95, 10058.61, 2775.66
## 8    30.00, 29.00, 28.00, 22794.10, 3142.81, 896.14
## 9   32.00, 30.00, 29.00, 14497.35, 5284.82, 1697.62
## 10   36.00, 34.00, 32.00, 9394.17, 4233.61, 2289.96
## 11    50.00, 48.00, 46.00, 21143.84, 154.53, 152.41
## 12    65.00, 60.00, 55.00, 664.49, 6596.92, 4833.59
## 13   90.00, 85.00, 80.00, 1741.33, 4195.38, 4498.53
## 14 120.00, 110.00, 100.00, 3352.29, 1525.55, 375.84
## 15  150.00, 140.00, 130.00, 655.23, 2970.63, 838.06
## 16 160.00, 150.00, 140.00, 2041.32, 1982.02, 400.70
## 17     240.00, 220.00, 210.00, 48.90, 330.74, 41.96
## 18     240.00, 210.00, 170.00, 286.30, 35.78, 19.50
## 19    260.00, 250.00, 240.00, 72.50, 616.23, 658.89
## 20    280.00, 270.00, 260.00, 113.48, 100.17, 45.71
## 21      310.00, 300.00, 280.00, 14.55, 73.14, 12.50
## 22   310.00, 300.00, 290.00, 300.01, 363.64, 235.42
## 23     390.00, 380.00, 370.00, 74.57, 122.00, 90.00
## 24      600.00, 570.00, 560.00, 15.50, 13.39, 46.99
## 25      610.00, 600.00, 520.00, 22.32, 34.80, 13.65
## 26     790.00, 780.00, 770.00, 19.00, 304.68, 18.42
## 27     730.00, 720.00, 710.00, 10.31, 68.83, 114.00
## 28     840.00, 830.00, 810.00, 32.08, 128.38, 12.43
## 29      860.00, 850.00, 840.00, 10.97, 25.55, 85.00
## 30 1000.00, 100.00, 2.00, 1355.70, 24.43, 100000.00
## 31    1000.00, 830.00, 160.00, 576.05, 11.46, 21.66
## 32  1000.00, 650.00, 120.00, 1316.09, 146.00, 19.10
## 33                                             NULL
## 34                                             NULL
## 35                                             NULL
## 36                                             NULL
## 37                                             NULL
## 38                                             NULL
## 39                                             NULL
## 40                                             NULL
## 41                                             NULL
## 42                                             NULL
## 43                                             NULL
## 44                                             NULL
## 45                                             NULL
## 46                                             NULL
## 47                                             NULL
## 48                                             NULL
## 49                                             NULL
## 50                                             NULL
## 51                                             NULL
## 52                                             NULL
## 53                                             NULL
## 54                                             NULL
## 55                                             NULL
## 56                                             NULL
## 57                                             NULL
## 58                                             NULL
## 59                                             NULL
## 60                                             NULL
##                                   ex.availableToLay ex.tradedVolume
## 1     5.70, 5.80, 5.90, 24863.44, 13855.08, 5265.34            NULL
## 2     5.90, 6.00, 6.20, 12366.35, 2764.29, 48117.37            NULL
## 3     7.60, 7.80, 8.00, 17942.07, 23290.98, 3044.74            NULL
## 4      8.20, 8.40, 8.60, 27297.89, 11360.41, 429.19            NULL
## 5  12.00, 12.50, 13.00, 32768.03, 12334.37, 2712.37            NULL
## 6   13.00, 13.50, 14.00, 18836.60, 14075.66, 980.59            NULL
## 7   19.50, 20.00, 21.00, 6945.81, 6603.81, 16010.11            NULL
## 8    32.00, 34.00, 36.00, 21817.22, 8145.76, 427.19            NULL
## 9   34.00, 36.00, 38.00, 14853.32, 5118.53, 1752.13            NULL
## 10    38.00, 40.00, 42.00, 6571.24, 2806.50, 851.85            NULL
## 11   55.00, 60.00, 65.00, 11830.95, 4691.20, 160.62            NULL
## 12     70.00, 75.00, 80.00, 4943.49, 382.48, 275.00            NULL
## 13  95.00, 100.00, 110.00, 1074.17, 114.19, 1007.68            NULL
## 14  130.00, 140.00, 160.00, 1842.55, 1161.15, 25.05            NULL
## 15    160.00, 170.00, 180.00, 533.92, 107.15, 47.35            NULL
## 16    170.00, 180.00, 190.00, 114.76, 738.03, 50.70            NULL
## 17     250.00, 260.00, 270.00, 51.16, 18.00, 176.56            NULL
## 18    260.00, 270.00, 280.00, 356.05, 89.23, 174.09            NULL
## 19      290.00, 450.00, 1000.00, 68.08, 35.31, 7.95            NULL
## 20      310.00, 320.00, 330.00, 19.10, 17.74, 10.00            NULL
## 21      320.00, 330.00, 340.00, 74.76, 22.63, 48.34            NULL
## 22     330.00, 340.00, 350.00, 10.00, 75.34, 121.89            NULL
## 23      410.00, 420.00, 430.00, 33.36, 10.14, 26.30            NULL
## 24      610.00, 840.00, 1000.00, 12.22, 17.31, 5.58            NULL
## 25      640.00, 650.00, 660.00, 14.00, 15.92, 50.00            NULL
## 26      820.00, 830.00, 840.00, 39.80, 33.30, 53.88            NULL
## 27      790.00, 800.00, 830.00, 13.12, 12.01, 42.46            NULL
## 28      860.00, 870.00, 880.00, 10.15, 47.93, 48.00            NULL
## 29     880.00, 890.00, 940.00, 139.63, 33.00, 15.70            NULL
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

## Find all submarkets of a market



```r
all_events <- listEvents(eventTypeIds = football_eventtypeid, 
                         competitionIds = worldcup_competitionid, 
                         toDate = "2019-05-30T12:00:00Z")

OpeningMatch_id <- subset(all_events$event, name == "Russia v Saudi Arabia")$id

OpeningMatch_Catalogue <- 
    listMarketCatalogue(eventTypeIds = football_eventtypeid, 
                        competitionIds = worldcup_competitionid, 
                        toDate = "2019-05-30T12:00:00Z", 
                        eventIds = OpeningMatch_id,
                        marketTypeCodes = all_MarketTypes$marketType)                    

OpeningMatch_Catalogue
```

```
##       marketId           marketName          marketStartTime totalMatched
## 1  1.137593504           Goal Lines 2018-06-14T15:00:00.000Z        12.53
## 2  1.137593428      Half Time Score 2018-06-14T15:00:00.000Z         0.00
## 3  1.137593404 Over/Under 0.5 Goals 2018-06-14T15:00:00.000Z       156.26
## 4  1.137593415 Over/Under 4.5 Goals 2018-06-14T15:00:00.000Z        12.04
## 5  1.137593416 Over/Under 6.5 Goals 2018-06-14T15:00:00.000Z       177.97
## 6  1.137593417 Over/Under 5.5 Goals 2018-06-14T15:00:00.000Z        63.37
## 7  1.137593350           Match Odds 2018-06-14T15:00:00.000Z     20286.68
## 8  1.137593356       Asian Handicap 2018-06-14T15:00:00.000Z       345.78
## 9  1.137593390 Both teams to Score? 2018-06-14T15:00:00.000Z       260.94
## 10 1.137593426            Half Time 2018-06-14T15:00:00.000Z         9.32
## 11 1.137593393  Half Time/Full Time 2018-06-14T15:00:00.000Z        40.84
## 12 1.137593351        Correct Score 2018-06-14T15:00:00.000Z        87.68
## 13 1.137593352 Over/Under 1.5 Goals 2018-06-14T15:00:00.000Z        15.02
## 14 1.137593353 Over/Under 2.5 Goals 2018-06-14T15:00:00.000Z       327.94
## 15 1.137593354 Over/Under 3.5 Goals 2018-06-14T15:00:00.000Z        15.11
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  runners
## 1                                                                                                                                                                                               7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, 7044483, 7044482, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, Under, Over, 0.5, 0.5, 0.75, 0.75, 1, 1, 1.25, 1.25, 1.5, 1.5, 1.75, 1.75, 2, 2, 2.25, 2.25, 2.5, 2.5, 2.75, 2.75, 3, 3, 3.25, 3.25, 3.5, 3.5, 3.75, 3.75, 4, 4, 4.25, 4.25, 4.5, 4.5, 4.75, 4.75, 5, 5, 5.25, 5.25, 5.5, 5.5, 5.75, 5.75, 6, 6, 6.25, 6.25, 6.5, 6.5, 6.75, 6.75, 7, 7, 7.25, 7.25, 7.5, 7.5, 7.75, 7.75, 8, 8, 8.25, 8.25, 8.5, 8.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 7044483, 7044482
## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      1, 3, 7, 2, 5, 6, 4, 9, 8, 4506345, 0 - 0, 1 - 1, 2 - 2, 1 - 0, 2 - 0, 2 - 1, 0 - 1, 0 - 2, 1 - 2, Any Unquoted , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 3, 7, 2, 5, 6, 4, 9, 8, 4506345
## 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        5851482, 5851483, Under 0.5 Goals, Over 0.5 Goals, 0, 0, 1, 2, 5851482, 5851483
## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        1222347, 1222346, Under 4.5 Goals, Over 4.5 Goals, 0, 0, 1, 2, 1222347, 1222346
## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        2542448, 2542449, Under 6.5 Goals, Over 6.5 Goals, 0, 0, 1, 2, 2542448, 2542449
## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        1485567, 1485568, Under 5.5 Goals, Over 5.5 Goals, 0, 0, 1, 2, 1485567, 1485568
## 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             25907, 51092, 58805, Russia, Saudi Arabia, The Draw, 0, 0, 0, 1, 2, 3, 25907, 51092, 58805
## 8  25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, 25907, 51092, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, Russia, Saudi Arabia, -4, 4, -3.75, 3.75, -3.5, 3.5, -3.25, 3.25, -3, 3, -2.75, 2.75, -2.5, 2.5, -2.25, 2.25, -2, 2, -1.75, 1.75, -1.5, 1.5, -1.25, 1.25, -1, 1, -0.75, 0.75, -0.5, 0.5, -0.25, 0.25, 0, 0, 0.25, -0.25, 0.5, -0.5, 0.75, -0.75, 1, -1, 1.25, -1.25, 1.5, -1.5, 1.75, -1.75, 2, -2, 2.25, -2.25, 2.5, -2.5, 2.75, -2.75, 3, -3, 3.25, -3.25, 3.5, -3.5, 3.75, -3.75, 4, -4, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 25907, 51092
## 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      30246, 110503, Yes, No, 0, 0, 1, 2, 30246, 110503
## 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            25907, 51092, 58805, Russia, Saudi Arabia, The Draw, 0, 0, 0, 1, 2, 3, 25907, 51092, 58805
## 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   103830, 103829, 16263119, 103827, 3710152, 1095816, 16263121, 1095813, 1095812, Russia/Russia, Russia/Draw, Russia/Saudi Arabia, Draw/Russia, Draw/Draw, Draw/Saudi Arabia, Saudi Arabia/Russia, Saudi Arabia/Draw, Saudi Arabia/Saudi Arabia, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 103830, 103829, 16263119, 103827, 3710152, 1095816, 16263121, 1095813, 1095812
## 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                1, 4, 9, 16, 2, 3, 8, 15, 5, 6, 7, 14, 10, 11, 12, 13, 9063254, 9063255, 9063256, 0 - 0, 0 - 1, 0 - 2, 0 - 3, 1 - 0, 1 - 1, 1 - 2, 1 - 3, 2 - 0, 2 - 1, 2 - 2, 2 - 3, 3 - 0, 3 - 1, 3 - 2, 3 - 3, Any Other Home Win, Any Other Away Win, Any Other Draw, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 1, 4, 9, 16, 2, 3, 8, 15, 5, 6, 7, 14, 10, 11, 12, 13, 9063254, 9063255, 9063256
## 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       1221385, 1221386, Under 1.5 Goals, Over 1.5 Goals, 0, 0, 1, 2, 1221385, 1221386
## 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               47972, 47973, Under 2.5 Goals, Over 2.5 Goals, 0, 0, 1, 2, 47972, 47973
## 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       1222344, 1222345, Under 3.5 Goals, Over 3.5 Goals, 0, 0, 1, 2, 1222344, 1222345
##    eventType.id eventType.name competition.id    competition.name event.id
## 1             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 2             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 3             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 4             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 5             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 6             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 7             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 8             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 9             1         Soccer        5614746 2018 FIFA World Cup 28500580
## 10            1         Soccer        5614746 2018 FIFA World Cup 28500580
## 11            1         Soccer        5614746 2018 FIFA World Cup 28500580
## 12            1         Soccer        5614746 2018 FIFA World Cup 28500580
## 13            1         Soccer        5614746 2018 FIFA World Cup 28500580
## 14            1         Soccer        5614746 2018 FIFA World Cup 28500580
## 15            1         Soccer        5614746 2018 FIFA World Cup 28500580
##               event.name event.timezone           event.openDate
## 1  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 2  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 3  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 4  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 5  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 6  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 7  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 8  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 9  Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 10 Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 11 Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 12 Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 13 Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 14 Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
## 15 Russia v Saudi Arabia  Europe/London 2018-06-14T15:00:00.000Z
```


```r
logoutBF(suppress = TRUE, sslVerify = TRUE)
```

```
## [1] "SUCCESS:"
```



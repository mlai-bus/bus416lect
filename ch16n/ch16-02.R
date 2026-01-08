# Prelims of time series

### 
### Ch 16 - 2
library(tidyverse)
library(forecast)

amtrak.df <- read_csv("Amtrak.csv")
amtrak.ts <- ts(amtrak.df[,-1],start = c(1991, 1), frequency = 12 )

# Create partitions
nValid <- 24
nTrain <- length(amtrak.ts) - nValid


train.ts <- window(amtrak.ts, start = c(1991, 1), end = c(1991, nTrain))
valid.ts <- window(amtrak.ts, start = c(1991, nTrain + 1), 
                   end = c(1991, nTrain + nValid))
autoplot(train.ts)
autoplot(valid.ts)

# Mean forecast: Simply the average value of all past perdiods
mean.fcast <- meanf(train.ts, h = nValid)

#  generate the naive and seasonal naive forecasts. 
#  Here forecast value is set equal to the corresponding value in the last period
naive.fcast <- naive(train.ts, h = nValid)
snaive.fcast <- snaive(train.ts, h = nValid)

# Check the accuracy of these against the actual valid.ts

accuracy(mean.fcast, valid.ts)

accuracy(naive.fcast, valid.ts)

accuracy(snaive.fcast, valid.ts)

#####
####Plot these forecasts against the actutal series
#plot the forecasts

autoplot(train.ts) +
  autolayer(valid.ts, PI =FALSE, series = "Actual") +
  autolayer( mean.fcast, series = "Mean Forecast") +
  autolayer( naive.fcast, series = "Naive Forecast") +
  autolayer( snaive.fcast, series = "Seasonal Naive Forecast")


## better chart
autoplot(train.ts) +
  autolayer(valid.ts, PI =FALSE, series = "Actual") +
  autolayer( mean.fcast, PI =FALSE, series = "Mean Forecast") +
  autolayer( naive.fcast, PI =FALSE, series = "Naive Forecast") +
  autolayer( snaive.fcast, PI =FALSE, series = "Seasonal Naive Forecast")


#list of packages to be used
# For all the textbook data



coreP <- c("tidyverse", "lubridate" , "MASS", "readxl", "haven",
           "scales","skmir", "broom", "data.table", "plotly" , "knitr",
           "fpp3", "forecast", 
           "pacman", "patchwork", "rlang", "devtools")

install.packages(coreP)

library(devtools)
install_github("econjjacob/mlbadata")

install.packages("caret", dependencies = c("Depends", "Suggests"))          

ch11 <- c("neuralnet" )
#ch10
ch09 <- c("rpart" , "rpart.plot", "adabag", "xgboost")
#ch08
#ch07 <- c()
ch06 <- c("leaps")
ch05 <- c("yardstick","pROC" ,"gains", "uplift","e1071")
ch04 <- c("FactoMineR", "ggbiplot")
ch03 <- c("ggthemes", "ggmap",  "treemap" , "GGally", "gridExtra",
          "ggrepel", "ggnetwork", "esquisse", "igraph" ,"treemapify")
ch02 <- c("sqldf", "ggcorrplot", "corrgram", "corrr")
ch01 <- c("fastDummies", "hablar",  "reshape" , "reshape2","dummies",
          "nycflights13", "gapminder", "aer", "psych", "mosaicData")



chps <- c(ch01, ch02 , ch03, ch04, ch06, ch09, ch11)
chps
install.packages(chps)

install.packages("ModelMetrics")

regressionSummary <- function(predicted, actual) {
  return (list(
    RMSE = caret::RMSE(predicted, actual),
    MAE = caret::MAE(predicted, actual)
  ))
}


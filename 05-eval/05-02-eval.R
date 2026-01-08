#### Table 5.1

# package forecast is required to evaluate performance
library(forecast)
library(caret)

# load file
toyota.df <- read.csv("ToyotaCorolla.csv")

# randomly generate training and validation sets
trainIndex <- createDataPartition(c(1:nrow(toyota.df)),
                                  p = 0.6,
                                  list = F)
toyota.train <- toyota.df[trainIndex, ]
toyota.valid <- toyota.df[-trainIndex, ]




# run linear regression model
reg <- lm(Price~., data=toyota.train[,-c(1,2,8,11)], 
          na.action=na.exclude)
summary(reg)
options(scipen = 999, digits = 4) # This turns off scientific notation and restricts the number of decimal places to 4
# options(scipen = 0) turn back on the scientific notation.

summary(reg)
pred_t <- predict(reg, na.action=na.pass)
pred_v <- predict(reg, newdata=toyota.valid[,-c(1,2,8,11)],
                  na.action=na.pass)

## evaluate performance
# training
accuracy(pred_t, toyota.train$Price)
# validation
accuracy(pred_v, toyota.valid$Price)



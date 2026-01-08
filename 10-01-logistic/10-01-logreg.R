library(tidyverse)
library(gains)
library(caret)
library(yardstick)
library(broom)

bank.df <- read.csv("UniversalBank.csv")
bank.df <- bank.df[ , -c(1, 5)]  # Drop ID and zip code columns.
# treat Education as categorical (R will create dummy variables)
bank.df$Education <- factor(bank.df$Education, levels = c(1, 2, 3), 
                            labels = c("Undergrad", "Graduate", "Advanced/Professional"))

glimpse(bank.df)
# partition data
set.seed(2)
train.index <- sample(c(1:dim(bank.df)[1]), dim(bank.df)[1]*0.6)  
train.df <- bank.df[train.index, ]
valid.df <- bank.df[-train.index, ]

# run logistic regression
# use glm() (general linear model) with family = "binomial" to fit a logistic 
# regression.
logit.reg <- glm(Personal.Loan ~ ., data = train.df, family = "binomial") 
options(scipen=999)
summary(logit.reg)

tidy(logit.reg)

# odds ratio

tidy(logit.reg, exponentiate = T)

result.1 <- tidy(logit.reg, exponentiate = T)

result.1 %>% 
  mutate(estimate = round(estimate,2),
         p.value = round(p.value, 4))

# Predictions: Remeber the predictions are a probability
# give the option type = "response"
# use broom here

trainpred.df <- augment(logit.reg,
                data = train.df,
                type.predict = "response")



logit.reg.trpred <- predict(logit.reg, type = "response")

# Let's now predict the outcome in the validation set. 
# We will also plot the lift chart, confusion matrix,
# and roc.

log.pred.valid <- augment(logit.reg,
                          newdata = valid.df,
                          type.predict = "response")


log.pred.valid2 <- log.pred.valid %>% 
  select(Personal.Loan, `.fitted`) %>%
  mutate(Personal.Loan.pred = ifelse(.fitted >0.5,1,0),
         actual.class = factor(Personal.Loan,order = T,
                               levels = c("1", "0")),
         pred.class = factor(Personal.Loan.pred,order = T,
                             levels = c("1", "0")))

## For confusion matrix, we need factors as classes


confusionMatrix(log.pred.valid2$pred.class, log.pred.valid2$actual.class)

lift1 <- lift_curve(log.pred.valid2, actual.class, .fitted)
autoplot(lift1)

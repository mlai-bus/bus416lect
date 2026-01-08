

ebay <- read.csv("eBayAuctions.csv", header = TRUE)
str(ebay)
#Duration needs to be a factor as well

ebay$Duration <- as.factor(ebay$Duration)
# install packages for pivot tables
# install.packages("rpivotTable")
library(rpivotTable)
rpivotTable(ebay, rows = "Category", cols = "Competetive.")

# Here we have several categories and seven days etc. If we use factor() in glm,
# It will include all these variables. Model selection will be meaningless.
# So we will need to explicitly use dummy variables. But first, a full model
library(pROC)
library(caret)
set.seed(12345)

trainIndex <- createDataPartition(ebay$Competitive. , 
                                  p = .6,
                                  list = FALSE)
ebay.train <- ebay[trainIndex, ]
ebay.valid <- ebay[-trainIndex, ]

# Run a full blown logit model

ebay.big <- glm(Competitive. ~. , 
                family = "binomial",
                data = ebay.train)
summary(ebay.big)

# Let's check it's predictive accuracy

prop.big <- predict(ebay.big, data = ebay.train, type = "response")
prop.big1 <- predict(ebay.big, data = ebay.train)
pred.big <- ifelse(prop.big > .5, 1, 0)
results.big <- data.frame(actual = ebay.train$Competitive. , prop = prop.big,
                          prop1 = prop.big1,
                          predicted = pred.big)
confusionMatrix(factor(results.big$predicted), factor(results.big$actual),
                positive = "1")

#roc curve
rocBig <- roc(results.big$actual, results.big$prop)
plot(rocBig, legacy.axes = TRUE)
auc(rocBig)


# We can not use closing price
delCPrice <- which(colnames(ebay.train)%in% "ClosePrice") 
ebay.train1 <- ebay.train[, -delCPrice]
ebay.valid1 <- ebay.valid[, -delCPrice]


# Now, let's repeat the above exercise in Model Building
ebay.full <- glm(Competitive. ~. , 
                 family = "binomial",
                 data = ebay.train1)
summary(ebay.full)

# Let's check it's predictive accuracy

prop.full <- predict(ebay.full, ebay.train1, type = "response")
pred.full <- ifelse(prop.full > .5, 1, 0)
results.full <- data.frame(actual = ebay.train1$Competitive. , prop = prop.full,
                           predicted = pred.full)
confusionMatrix(factor(results.full$predicted), factor(results.full$actual),
                positive = "1")
rocFullTrain <- roc(results.full$actual , results.full$prop)
auc(rocFullTrain)

###########
prop.full.valid <- predict(ebay.full, ebay.valid1, type = "response")
pred.full.valid <- ifelse(prop.full.valid > .5, 1, 0)
results.full.valid <- data.frame(actual = ebay.valid1$Competitive. , prop = prop.full.valid,
                                 predicted = pred.full.valid)


confusionMatrix(factor(results.full.valid$predicted), factor(results.full.valid$actual),
                positive = "1")
rocFullValid <- roc(results.full.valid$actual , results.full.valid$prop)
auc(rocFullValid)

###########


# Model selection
# Can not use the various factor variables as is. Why?

ebay.train1.step <- step(ebay.full, direction = "both")
summary(ebay.train1.step)


# Create Dummy Variables

dummies <-dummyVars(Competitive. ~ . , data = ebay,
                    levelsOnly = TRUE, fullRank = T)

# Imp: fullRank = T is ciritcal to avoid the dummy variable trap

ebayDum <- data.frame(predict(dummies, newdata = ebay))
### We have the dummy variables. 


#Do this for training set and combine the dependent variable.
dummies <-dummyVars(Competitive. ~ . , data = ebay.train1,
                    levelsOnly = TRUE, fullRank = T)

ebay.train1f <- data.frame(ebay.train1$Competitive., predict(dummies, newdata = ebay.train1))


# Now for validation set
dummies <-dummyVars(Competitive. ~ . , data = ebay.valid1,
                    levelsOnly = TRUE, fullRank = T)

ebay.valid1f <- data.frame(ebay.valid1$Competitive., predict(dummies, newdata = ebay.valid1))




### Building a Logit Model
ebay.new <- glm(ebay.train1.Competitive. ~. , 
                family = "binomial",
                data = ebay.train1f)
summary(ebay.new)
# Model selection
ebay.train1n.step <- step(ebay.new, direction = "both")
summary(ebay.train1n.step)
# Let's check it's predictive accuracy

rm(prop.new)
prop.new <- predict(ebay.new, data = ebay.train1f, type = "response")
pred.new <- ifelse(prop.new > .5, 1, 0)
results.new <- data.frame(actual = ebay.train1f$ebay.train1.Competitive. , prop = prop.new,
                          predicted = pred.new)
summary(prop.new)
confusionMatrix(factor(results.new$predicted), factor(results.new$actual),
                positive = "1")

rocNew <- roc(results.new$actual , results.new$prop)
auc(rocNew)
plot(rocNew, legacy.axes = TRUE)

####
####Now for the validation set
prop.newv <- predict(ebay.new, ebay.valid1f, type = "response")
pred.newv <- ifelse(prop.newv > .5, 1, 0)
results.newv <- data.frame(actual = ebay.valid1f$ebay.valid1.Competitive. , prop = prop.newv,
                           predicted = pred.newv)

confusionMatrix(factor(results.newv$predicted), factor(results.newv$actual),
                positive = "1")

rocNewv <- roc(results.newv$actual , results.newv$prop)
auc(rocNewv)
plot(rocNewv, legacy.axes = TRUE)

##########################################
##########################################
#########################################

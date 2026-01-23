#### Table 2.3 
library(tidyverse)
library(readr)
library(caret)

# This is the default dataframe. Notice the difference in formatting
housing.df <- read.csv("data/WestRoxbury.csv", header = T,
                       stringsAsFactors = FALSE)  # load data
str(housing.df)

# Let us create the factor variable

housing.df$REMODEL <- factor(housing.df$REMODEL,
                               levels = c("Recent", "Old", "None"))

# random sample of 5 observations
s <- sample(row.names(housing.df), 5)

s

housing.df[s,]


#### Table 2.5

names(housing.df)  # print a list of variables to the screen.
t(t(names(housing.df)))  # print the list in a useful column format

#colnames(housing.df)[1] <- c("TOTAL_VALUE")  # change the first column's name


### Create dummy variables

#### Table 2.6
# Option 1: use dummies package
install.packages("fastDummies")

library(fastDummies)
housing.df <- dummy_cols(housing.df)
names(housing.df)
?dummy_cols
# This is very useful function for regression.
housing.df <- housing.df[, -c(15:17)]

# One problem is that all levels are encoded. If we include all three in a
## in regression, we will have the "dummy-variable trap".

# Use the caret package

dum1 <- dummyVars( ~., data = housing.df)
trnsf1 <- data.frame(predict(dum1, housing.df))
# here, remodel got removed but all three levels got created

dum1 <- dummyVars( ~., data = housing.df, 
                   fullRank = T)
trnsf2 <- data.frame(predict(dum1, housing.df))

# With fullrank = T, the first level is omitted to remove lin. dependencies
# Note: be careful about creating nonsense factors like zip code, names etc


#### Table 2.9

# use set.seed() to get the same partitions when re-running the R code.


## partitioning into training (60%) and validation (40%) 
###################################

# randomly sample 60% of the row IDs for training; the remaining 40% serve as
# validation



set.seed(1234)
trainind <- createDataPartition(housing.df$TOTAL.VALUE,
                                p = 0.6, list = F)
train.df <- housing.df[trainind, ]
valid.df <- housing.df[-trainind, ]


# The above will be the preferred method in this course.

#### Table 2.11
?lm

# In basic regression using the lm() function, we do not
## really need to create dummy variables.

reg <- lm(TOTAL.VALUE ~ .-TAX, data = train.df) # remove variable "TAX"
summary(reg)

tr.res <- data.frame(train.df$TOTAL.VALUE, reg$fitted.values, reg$residuals)
head(tr.res)



#### Table 2.12

pred <- predict(reg, newdata = valid.df)
vl.res <- data.frame(valid.df$TOTAL.VALUE, pred, 
                     residuals = valid.df$TOTAL.VALUE - pred)
head(vl.res)

# another option to view tidy results

library(broom)

# obtain results in a tidy format
tidy(reg)

# view model fit statistics
glance(reg)

# including predicted values and residuals

pred.broom <- augment(reg)

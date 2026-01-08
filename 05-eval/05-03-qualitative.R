#### Table 5.1

# package forecast is required to evaluate performance

#### Table 5.5
install.packages("yardstick")
library(tidyverse)
library(caret)
library(e1071)

owner.df <- read.csv("ownerExample.csv")
owner.df$Class <- factor(owner.df$Class, order = T,
                   levels = c("owner", "nonowner"))

confusionMatrix(as.factor(ifelse(owner.df$Probability>0.5, 'owner', 'nonowner')), 
                owner.df$Class)
confusionMatrix(as.factor(ifelse(owner.df$Probability>0.25, 'owner', 'nonowner')), 
                owner.df$Class)
confusionMatrix(as.factor(ifelse(owner.df$Probability>0.75, 'owner', 'nonowner')), 
                owner.df$Class)


#### Figure 5.5

library(pROC)
r <- roc(owner.df$Class, owner.df$Probability)
plot.roc(r)

# compute auc
auc(r)

### Lift charts
# There are several methods for this. yardstick package seems
## to be the most straightforward

library(yardstick)
lift1 <- lift_curve(owner.df, Class, Probability)
autoplot(lift1)



#### Figure 5.7

# use gains() to compute deciles. 
library(gains)

# We need the predicted variable to be numeric, with the 1st
#  class to be the target class and 0 for nonowners.

owner.df2 <- owner.df %>% 
  mutate(truth = ifelse(Class == "owner", 1, 0))

gain <- gains(owner.df2$truth, owner.df2$Probability)
barplot(gain$mean.resp / mean(owner.df2$truth), names.arg = gain$depth, xlab = "Percentile", 
        ylab = "Mean Response", main = "Decile-wise lift chart")


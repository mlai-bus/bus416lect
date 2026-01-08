library(yardstick)
str(data(hpc_cv))

library(dplyr)

# hpc_cv is an included data set with pred as the prediction,
## four classes with VF as outcome of interest.

df <- hpc_cv %>% filter(Resample == "Fold01")

# To recreate predicted class from the probabilities
## Note that in multiclass setting, we go with the max

df <- df %>% 
      mutate(pred1 = apply(df[,3:6], 1, which.max),
             predcl = factor(pred1, labels = c("VF", "F", "M" , "L")))
roc_auc(df, obs, VF:L)


df %>% roc_curve(obs, VF:L) %>%
  autoplot()


# getting these results by groups.

hpc_cv %>%
  group_by(Resample) %>%
  roc_auc(obs, VF:L)

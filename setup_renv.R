############################################
# R ENVIRONMENT SETUP FOR Individual Chapters (INSTRUCTOR)
# These are all unique packages not installed by core_pkgs
# Install them chunk by chunk in wsl
############################################



# =========================
# CHAPTER 1 – DATA BASICS
# =========================
ch01_pkgs <- c(
  "fastDummies",
  "hablar",
  "reshape2",
  "nycflights13"
)

install.packages(ch01_pkgs)


# =========================
# CHAPTER 2 – EDA
# =========================
ch02_pkgs <- c(
  "sqldf",
  "ggcorrplot",
   "corrr"
)
install.packages(ch02_pkgs)

# =========================
# CHAPTER 3 – VISUALIZATION
# =========================
ch03_pkgs <- c(
  "ggnetwork",
  "esquisse",
  "treemapify"
)
install.packages(ch03_pkgs)

# =========================
# CHAPTER 4 – DIM REDUCTION
# =========================
ch04_pkgs <- c(
  "FactoMineR"
)
install.packages(ch04_pkgs)
library(devtools)
install_github("vqv/ggbiplot")
# =========================
# CHAPTER 5 – CLASSIFICATION
# =========================
ch05_pkgs <- c(
  "yardstick",
  "gains",
  "pROC",
  "e1071"
)

#install.packages(ch05_pkgs)

# =========================
# CHAPTER 6 – MODEL SELECTION
# =========================
ch06_pkgs <- c(
  "leaps"
)
#install.packages(ch06_pkgs)

# =========================
# CHAPTER 9 – TREE MODELS
# =========================
ch09_pkgs <- c(
  "adabag",
  "xgboost"
)

install.packages(ch09_pkgs)

# =========================
# CHAPTER 11 – NEURAL NETS
# =========================
ch11_pkgs <- c(
  "neuralnet"
)
install.packages(ch11_pkgs)

install_github("j-a-jacob/mlbadata")

# ---- 4. Combine into one master list ----
course_packages <- list(
  core = core_pkgs,
  ch01 = ch01_pkgs,
  ch02 = ch02_pkgs,
  ch03 = ch03_pkgs,
  ch04 = ch04_pkgs,
  ch05 = ch05_pkgs,
  ch06 = ch06_pkgs,
  ch09 = ch09_pkgs,
  ch11 = ch11_pkgs
)

all_pkgs <- unique(unlist(course_packages))

# ---- 4. Install all CRAN packages ----
#install.packages(
#  all_pkgs,
#  dependencies = c("Depends", "Imports", "Suggests")
#)







############################################
# END OF SETUP
############################################

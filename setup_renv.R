############################################
# R ENVIRONMENT SETUP FOR COURSE (INSTRUCTOR)
############################################

# ---- 1. Install and initialize renv ----
install.packages("renv")
library(renv)

renv::init(bare = TRUE)
renv::status()


##### Note: the individual install commands are there in case the meta list
####### fails to install.


# ---- 2. Package lists ----

# =========================
# CORE PACKAGES (ALL TERM)
# =========================
core_pkgs <- c(
  "tidyverse",
  "tidymodels",
  "caret",
  "lubridate",
  "MASS",
  "readxl",
  "haven",
  "scales",
  "skimr",
  "broom",
  "data.table",
  "plotly",
  "knitr",
  "forecast",
  "fpp3",
  "pacman",
  "patchwork",
  "rlang"
)

#install.packages(core_pkgs, dependencies = c("suggests", "depends"))
# =========================
# CHAPTER 1 – DATA BASICS
# =========================
ch01_pkgs <- c(
  "fastDummies",
  "hablar",
  "reshape",
  "reshape2",
  "nycflights13",
  "gapminder",
  "AER",
  "psych",
  "mosaicData"
)

#install.packages(ch01_pkgs)


# =========================
# CHAPTER 2 – EDA
# =========================
ch02_pkgs <- c(
  "sqldf",
  "ggcorrplot",
  "corrgram",
  "corrr"
)
#install.packages(ch02_pkgs)

# =========================
# CHAPTER 3 – VISUALIZATION
# =========================
ch03_pkgs <- c(
  "ggthemes",
  "treemap",
  "GGally",
  "gridExtra",
  "ggrepel",
  "ggnetwork",
  "esquisse",
  "igraph",
  "treemapify"
)
#install.packages(ch03_pkgs)

# =========================
# CHAPTER 4 – DIM REDUCTION
# =========================
ch04_pkgs <- c(
  "FactoMineR"
)
#install.packages(ch04_pkgs)

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
  "rpart",
  "rpart.plot",
  "adabag",
  "xgboost"
)

#install.packages(ch09_pkgs)

# =========================
# CHAPTER 11 – NEURAL NETS
# =========================
ch11_pkgs <- c(
  "neuralnet",
  "reticulate"
)
#install.packages(ch11_pkgs)

# =========================
# DEV / GITHUB PACKAGES
# =========================
dev_pkgs <- c(
  "devtools"
)
#install.packages(dev_pkgs)

# ---- 3. Combine into one master list ----
course_packages <- list(
  core = core_pkgs,
  ch01 = ch01_pkgs,
  ch02 = ch02_pkgs,
  ch03 = ch03_pkgs,
  ch04 = ch04_pkgs,
  ch05 = ch05_pkgs,
  ch06 = ch06_pkgs,
  ch09 = ch09_pkgs,
  ch11 = ch11_pkgs,
  dev  = dev_pkgs
)

all_pkgs <- unique(unlist(course_packages))

# ---- 4. Install all CRAN packages ----
install.packages(
  all_pkgs,
  dependencies = c("Depends", "Imports", "Suggests")
)

# ---- 5. Install GitHub-only packages ----
library(devtools)


install_github("j-a-jacob/mlbadata")
install_github("vqv/ggbiplot")


# ---- 6. Snapshot the environment (CRITICAL) ----
renv::record("renv@1.1.6")
renv::snapshot()

############################################
# END OF SETUP
############################################

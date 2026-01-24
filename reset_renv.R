############################################
# RESET renv AND INSTALL CORE DEPENDENCIES
# Instructor-use script
############################################

cat("=== Removing existing renv setup ===\n")

# Remove renv infrastructure (safe even if not present)
unlink("renv", recursive = TRUE, force = TRUE)
unlink("renv.lock", force = TRUE)

# Remove renv activation from .Rprofile if present
if (file.exists(".Rprofile")) {
  lines <- readLines(".Rprofile")
  lines <- lines[!grepl("renv", lines)]
  writeLines(lines, ".Rprofile")
}

cat("Old renv files removed.\n\n")
############################################
# Reinitialize renv
############################################

# Some packages needed
# sudo apt install cargo cmake gdal-bin gsfonts libcairo2-dev 
#libgdal-dev libgit2-dev libgmp3-dev libmagick++-dev libnode-dev 
#libudunits2-dev libx11-dev rustc
# sudo apt-get install protobuf-compiler libprotobuf-dev


cat("=== Initializing fresh renv ===\n")

install.packages("renv", lib = Sys.getenv("R_LIBS_USER"))
library(renv)

renv::init(bare = TRUE)

############################################
# CORE PACKAGES (INSTALL ONCE)
############################################

cat("=== Installing core packages ===\n")

core_pkgs <- c(
   "tidyverse",
  "tidymodels",
  "caret",
  "lubridate",
  "MASS",
  "readxl",
  "haven"
)

install.packages(core_pkgs, dependencies = c("Suggests", "Depends", "Imports"))



core_pkgs <- c(
  "scales",
  "skimr",
  "broom",
  "knitr",
  "forecast",
  "fpp3",
  "pacman",
  "patchwork",
  "rlang", 
  "devtools"
)

install.packages(core_pkgs, dependencies = c("Suggests", "Depends", "Imports"))
install.packages("igraph", dependencies = c("Suggests", "Depends", "Imports"))
library(devtools)



install_github("j-a-jacob/mlbadata")

############################################
# SNAPSHOT CORE ENVIRONMENT
############################################

cat("=== Snapshotting renv environment ===\n")

renv::snapshot()

cat("\n=== renv reset and core install complete ===\n")

#================================ Packages ================================

# Set environment for TERRA
#Sys.setenv(PROJ_LIB = "C:/Users/natha/AppData/Local/R/win-library/4.6/terra/proj")

#' [WHEN RUNNING FOR THE FIRST TIME] Install lidR & lasR
# install.packages(c("rlas", "lidR"), repos = c("https://r-lidar.r-universe.dev", "https://cloud.r-project.org")); install.packages('lasR', repos = 'https://r-lidar.r-universe.dev'); install.packages('lidRviewer', repos = 'https://r-lidar.r-universe.dev')

# libraries needed
libs <- c("httr", "jsonlite", "ggplot2", "terra", "leaflet", "ncdf4", "tidyr", "dplyr", "readr", "targets", "usethis", "sf", "targets", "visNetwork", "tarchetypes", "tidyterra", "performance", "see", "RColorBrewer", "lme4", "nlme", "readxl", "writexl", "emmeans", "splines", "lspline", "ggeffects", "lubridate", "cowplot", "gridGraphics", "broom", "DT", "flextable", "wesanderson", "ggspatial", "extrafont", "aqp", "lidR", "lasR", "lidRviewer", "shapefiles")

# install missing libraries
installed_libs <- libs %in% rownames(installed.packages())
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs])
}

# load libraries
lapply(libs, library, character.only = T)


#================================ Setup ================================

# Set target options:
tar_option_set(
  packages = libs, # Packages needed for tasks
  error = "continue" # tar_make() will continue even if it hits one error
)

# Run the R scripts in the R/ folder with functions
tar_source("R/classification-functions.R")
# tar_source(R/ohter-functions.R)

#' [WHEN RUNNING FOR THE FIRST TIME]
# Run commented out code below to clear storage:
# tar_destroy(destroy = c("objects")); file.remove(list.files("_plot_outputs", full.names = TRUE))


#================================ Targets ================================


# Define a list with targets. Order does not matter
list(
  
  ## Template ====
  tar_target(
    tka_files,
    list.files("_tka-files", pattern = "\\.TKA$", full.names = TRUE),
    cue = tar_cue(mode = "always")
  )
  
)
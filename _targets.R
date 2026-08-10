#================================ Packages ================================

# Set environment for TERRA
#Sys.setenv(PROJ_LIB = "C:/Users/natha/AppData/Local/R/win-library/4.6/terra/proj")

#' [WHEN RUNNING FOR THE FIRST TIME] Install lidR & lasR
# install.packages(c("rlas", "lidR"), repos = c("https://r-lidar.r-universe.dev", "https://cloud.r-project.org")); install.packages('lasR', repos = 'https://r-lidar.r-universe.dev'); install.packages('lidRviewer', repos = 'https://r-lidar.r-universe.dev')

# libraries needed
libs <- c("httr", "jsonlite", "ggplot2", "terra", "leaflet", "ncdf4", "tidyr", "dplyr", "readr", "targets", "usethis", "sf", "targets", "visNetwork", "tarchetypes", "tidyterra", "performance", "see", "RColorBrewer", "lme4", "nlme", "readxl", "writexl", "emmeans", "splines", "lspline", "ggeffects", "lubridate", "cowplot", "gridGraphics", "broom", "DT", "flextable", "wesanderson", "ggspatial", "extrafont", "aqp", "lidR", "lasR", "lidRviewer", "shapefiles", "RCSF", "future")

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
  
  ## Import Point Cloud ====
  tar_target(
    cloud_path,
    "H:/_terrestrial-lidar_working/_working/2026-08-06_WD/combined_range-100_o005.las"
  ),
  
  ### Tile point cloud ====
  tar_target(
    tile_paths,
    tile_cloud(cloud_path) # This output is a list of file paths
  ),
  
  ### Tracks the actual files on disk, branches over them ====
  tar_files( # This facilitates branching which is needed for the next step 
    chunks,
    chunk_paths
  )
  
)
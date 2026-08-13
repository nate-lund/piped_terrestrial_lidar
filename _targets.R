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
tar_source("R/preprocessing-functions.R")
# tar_source(R/other-functions.R)

#' [WHEN RUNNING FOR THE FIRST TIME]
# Run commented out code below to clear storage:
# tar_destroy(destroy = c("objects"))

# Some performance tools for lidR levers
plan(multisession, workers = 16)  # Adjust to your core count
set_lidr_threads(16) # ^


#================================ Targets ================================


# Define a list with targets. Order does not matter
list(
  
  ## Import Point Clouds ====
  tar_files(
    las_files,
    list.files(
      #' [SET] the location where full .laz or .las files are stored
      "H:/_terrestrial-lidar_working/_working/_full_clouds",
      pattern = "\\.(las|laz)$",
      full.names = TRUE,
      ignore.case = TRUE
    )
  ),
  
  ### Tile point clouds, branching over each .las ====
  tar_target(
    tiles,
    tile_cloud(
      las_path   = las_files,
      #' [SET] the location where you want tiles
      output_folder = "H:/_terrestrial-lidar_working/_working/_tiles",
      tile_size = 25 # tile size in m
    ),
    pattern = map(las_files),
    format  = "file"
  ),

  ### Perform a rough classification ====
  tar_target(
    rough_classification,
    rough_classify(
      tiles,
      #' [SET] the location where you want roughly-classified tiles
      output_folder = "H:/_terrestrial-lidar_working/_working/_classification-1"
      ),
    pattern = map(tiles),
    format  = "file"
  ),
  
  ### Save only ground points ====
  tar_target(
    ground_only,
    filter_ground(
      tiles = rough_classification,
      #' [SET] the location where you want roughly-classified tiles
      output_folder = "H:/_terrestrial-lidar_working/_working/_ground-only"
    ),
    pattern = map(tiles),
    format  = "file"
  )

  
)
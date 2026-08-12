#================================ Tile .las ================================

#' [Test code]
# las_path =  "H:/_terrestrial-lidar_working/_working/_clouds/2026-08-06_WD_o005.las"

# output_folder = "H:/_terrestrial-lidar_working/_working/_targets_files/_tiles"

tile_cloud = function(las_path, output_folder){
  
  # Grab .las file name
  base_name <- tools::file_path_sans_ext(basename(las_path))
  
  # Make a folder in the /_tiles directory for storing tiles
  tile_folder  <- file.path(output_folder, base_name)
  dir.create(tile_folder, recursive = TRUE, showWarnings = FALSE)
  
  # Build a catalog around the single file. This does NOT load points.
  ctg <- readLAScatalog(las_path)
  
  # A .lax lets catalog_retile() jump straight to the points inside each
  # chunk's bounding box. Build one if not already present
  lax_path <- paste0(tools::file_path_sans_ext(las_path), ".lax")
  if (!file.exists(lax_path)) {
    rlas::writelax(las_path)
  }
  
  # Options for catalog_retile()
  opt_chunk_size(ctg)      <- 75 # Tile size in meters 
  opt_chunk_buffer(ctg)    <- 0 # Buffer, 0 means just splitting
  opt_chunk_alignment(ctg) <- c(0, 0) # Aligns tile edges to global 0,0 grid
  opt_laz_compression(ctg) <- TRUE
  opt_output_files(ctg)    <- file.path(tile_folder, paste0(base_name, "_{XLEFT}_{YBOTTOM}"))
  opt_laz_compression(ctg) = TRUE # If FALSE, retile will produce .las instead of .laz
  
  # catalog_retile() processes and writes tile-by-tile, never loading cloud into
  # memory. Takes some time, shows progress in a plot. 
  # Filenames use lidR's {XLEFT}_{YBOTTOM}
  print(base_name)
  tiled_ctg <- catalog_retile(ctg)
  
  # Save a plot of the chunk pattern over the extent of the cloud
  png(file.path(tile_folder, "ctg_plot.png"), width = 800, height = 600, res = 100)
  plot(ctg, chunk = TRUE)
  dev.off()
  
  return(tiled_ctg$filename)
}


#================================ Rough Classification ================================

#' [Test code]
# tiles = tar_read(tiles)

# output_folder = "H:/_terrestrial-lidar_working/_working/_targets_files/_tiles_rough-class"

rough_classify = function(tiles, output_folder){
 
  # Grab original .las file name
  base_name <- sub("_[-0-9]+_[-0-9]+$", "", tools::file_path_sans_ext(basename(tiles[1])))
  
  # Make a folder in the /_tiles directory for storing tiles
  tile_folder  <- file.path(output_folder, base_name)
  dir.create(tile_folder, recursive = TRUE, showWarnings = FALSE)

  # Create catalog, does not load points
  ctg = readLAScatalog(tiles)
  
  # Options for ctg management (buffer not needed, made on the fly)
  opt_output_files(ctg)    <- file.path(tile_folder, "{*}_classified")
  opt_laz_compression(ctg) = TRUE # If FALSE, retile will produce .las instead of .laz
  
  
  # Do a pretty low-res classification to remove trees
  ctg_csf = classify_ground(ctg,
                            csf(
                              sloop_smooth = TRUE, 
                              class_threshold = 1, 
                              cloth_resolution = 1, 
                              time_step = 1
                            )
  )
  
  return(ctg_csf$filename)
}












#================================ ? ================================

# Set AOI, a 10x10m square
max_x = 450848
max_y = 4967649
min_x = max_x - 10
min_y = max_y - 10

print(c(min_x, min_y, max_x, max_y))

# Load LAS, clipping to AOI
las <- readLAS("H:/_terrestrial-lidar_working/_working/2025-05-29_WD/combined_range_100_o005_real.las",
               filter = "-keep_xy 450838 4967639  450848 4967649") # min_x min_y max_x max_y

# Force coordinate system to NAD83 / UTM zone 15N (which we know it is in)
st_crs(las) <- 26915

# Quickly test classify (using Progressive TIN Densification)
las_class <- classify_ground(las, ptd(20))

# Visualize 
plot(las) # Plot the standard way
view(las_class) # Plot with color
print(las) # View Info
summary(las) # View more info

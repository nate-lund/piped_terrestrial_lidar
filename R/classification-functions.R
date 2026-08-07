#================================ ? ================================

# For WD
# Set AOI, a 10x10m square
# max_x = 450848
# max_y = 4967649
# min_x = max_x - 10
# min_y = max_y - 10

# For LRW
#Set AOI, a 10x10m square
max_x = 441227
max_y = 4988956
min_x = max_x - 1
min_y = max_y - 1


print(c(min_x, min_y, max_x, max_y))

# Load LAS, clipping to AOI
las <- readLAS("H:/_terrestrial-lidar_working/_working/2025-05-28_LRW/combined_range-100_o005.las",
               filter = "-keep_xy 441217 4988946  441227 4988956") # min_x min_y max_x max_y

# Force coordinate system to NAD83 / UTM zone 15N (which we know it is in)
st_crs(las) <- 26915

# Visualize 
plot(las) # Plot the standard way
view(class) # Plot with color
print(las) # View Info
summary(las) # View more info


#================================ Classification ================================

# Quickly test classify (using Progressive TIN Densification)
las_class <- classify_ground(las, ptd(20))

las_class2 <- classify_ground(las, algorithm = pmf(ws = 5, th = 3))


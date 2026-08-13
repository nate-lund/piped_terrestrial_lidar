#================================ Test ================================

# Read .las
las = readTLS(
  "H:/_terrestrial-lidar_working/_working/_classification-1/2026-08-06_WD_o005/2026-08-06_WD_o005_-50_25_classified.las",
  filter = "-keep_class 2"
  )

# Filter out bright white points for visualziation
las_clean <- filter_poi(las, R <= 60000 & G <= 60000 & B <= 60000)

plot(las_clean, color = "RGB")

# Create a color index value to help determine vegetation
index <- 2 * las$G - las$R - las$B

las <- add_lasattribute(
  las,
  x = index,
  name = "GLI",
  desc = "Green Leaf Index (2G - R - B)"
)

plot(las, color = "GLI")

plot(las, color = "Intensity")

# Histograms
hist(las$GLI)
hist(las$Intensity)

range(las$Classification)

head(las@data)

hist(las$B)
hist(las$Intensity)

plot(las, color = "RGB")

table(las$Classification)

table(las$Color)

las_ground <- filter_poi(las, Classification == 2)
  



# Do a better classification 
las_tin = classify_ground(las_ground,
                          ptd(
                            res = 10, # 10 recommended in forests 
                            angle = 30,
                            distance = 3
                            )
                          )

plot(las_tin, color = "Classification")


#View a transect
p1 <- c(-30, 25)
p2 <- c(-30, 49)
las_tr <- clip_transect(las, p1, p2, width = 0.1, xz = TRUE)

ggplot(payload(las_tr), aes(X,Z, color = Classification)) + 
  geom_point(size = 0.5) + 
  coord_equal() + 
  theme_minimal()



#================================ Test ================================

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
min_x = max_x - 5
min_y = max_y - 5

#' [COPY THESE VALUES INTO readTLS below]
print(c(min_x, min_y, max_x, max_y))

# Load whole LAS
las <- readTLS("H:/_terrestrial-lidar_working/_working/2025-05-28_LRW/combined_range-100_o005.las")

# Load LAS, clipping to AOI
las <- readTLS("H:/_terrestrial-lidar_working/_working/2025-05-28_LRW/combined_range-100_o005.las",
               filter = "-keep_xy 441222 4988951  441227 4988956") # min_x min_y max_x max_y

# Force coordinate system to NAD83 / UTM zone 15N (which we know it is in)
st_crs(las) <- 26915

# Visualize 
#plot(las) # Plot the standard way
#view(las) # Plot with color
#print(las) # View Info
#summary(las) # View more info
#las_check(las) # To do a quick diagnostic



#las <- lidR::readLAS("H:/_terrestrial-lidar_working/_working/_full_clouds/2026-08-06_WD_o005.laz")
#lidR::writeLAS(las, "H:/_terrestrial-lidar_working/_working/_full_clouds/2026-08-06_WD_o005.las")



#================================ Rough Cut of Classification ================================
# The goal is to just remove trees, shrubs, logs, etc. from the point cloud. Allows us to
# classify the ground surface and use less memory.

# Do a pretty low-res classification to remove trees
las_csf = classify_ground(las,
                          csf(
                            sloop_smooth = TRUE, 
                            class_threshold = 1, 
                            cloth_resolution = 1, 
                            time_step = 1
                          )
)

# See classifications point counts (2 = ground)
#table(las_csf$Classification)

# Filter for ground
csf_ground <- filter_poi(las_csf, Classification == 2)

# View if needed
view(csf_ground)

#================================ Real ================================



las <- readTLS("H:/_terrestrial-lidar_working/_working/_targets_files/_tiles_rough-class/2026-08-06_WD_o005/2026-08-06_WD_o005_-75_0_classified.laz",
               filter = "-keep_class 2")

view(las)

# Quickly test classify (using Progressive TIN Densification)
las_ptd <- classify_ground(las,
                           ptd(
                             res = 50,
                             angle = 40,
                             distance = 3
                           )
)

summary(las_ptd)

view(las_ptd)

#las_class2 <- classify_ground(las, algorithm = pmf(ws = 5, th = 3))

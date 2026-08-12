

csv = read_csv("C:/Users/natha/Box/_data/_spatial/_terrestiral-lidar/TLS_VABJ_survey-points.csv")

pts <- st_as_sf(csv, coords = c("POINT_X", "POINT_Y"), crs = 32618, remove = FALSE)
pts <- st_transform(pts, crs = 4326)

csv$lon <- st_coordinates(pts)[, "X"]
csv$lat <- st_coordinates(pts)[, "Y"]

write.csv(csv, "output.csv", row.names = FALSE)
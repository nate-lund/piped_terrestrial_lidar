

las = readTLS(
  "H:/_terrestrial-lidar_working/_working/2026-08-25_LL2_o005_crop.las"
)

view(las, color = "Reflectance")

# Progressive TIN Densification (PTD)
las_tin = classify_ground(las,
                          ptd(
                            # Res: The resolution must be chosen large enough so that the lowest point in each cell is actually a ground point
                            res = 10, # 10 recommended in forests, seems to have minimal impact
                            # Angle: Use smaller values (e.g., 20) for flat terrain and larger values (e.g., 40) for mountainous regions.
                            angle = 10,
                            distance = 0.05,
                            spacing = 0.005, # Should be equal to the spacing of the ground points
                          )
)


plot(las_tin, color = "Classification")

las@data

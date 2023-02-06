
library(sf)

map <- st_read("data/wijk_2020_v3.shp")
map <- map[map$H2O == "NEE", c("WK_CODE", "WK_NAAM", "GM_CODE", "GM_NAAM", "geometry")]


# Write map with neighbourhoods in GeoJSON format
dir.create("data_proces", showWarnings = FALSE, recursive = TRUE)
fn <- "data_proces/wijk_2020.json"
if (file.exists(fn)) file.remove(fn)
st_write(map, fn, driver = "GeoJSON")


# Simplify map
# Needs mapshaper installed:
# sudo npm install -g mapshaper
#
system(paste("mapshaper",
  "-i data_proces/wijk_2020.json",
  # Simplify the map. Use planar as the map is already projected; 
  # resolution = 250 m
  "-simplify 2.5% planar interval=250",
  # Neighbourhoods consisting of more than 1 region are split into seperate 
  # records
  #"-explode",
  "-o data_proces/wijk_2020_simplified.topojson"))

# Read the simplified map
map <- st_read("data_proces/wijk_2020_simplified.topojson")

# Read original map to compare to
map0 <- st_read("data_proces/wijk_2020.json")
# Compare simplified map to original map
par(mar = c(0,0,0,0)+0.1)
plot(map0$geometry[map0$GM_NAAM == "Rotterdam"], border ="red", col = "lightgray")
plot(map$geometry[map$GM_NAAM == "Rotterdam"], add = TRUE)


# ===== ROTTERDAM =====

rdam <- map[map$GM_NAAM == "Rotterdam", ]

# Handle duplicate names
#stopifnot(all(table(rdam$WK_CODE)<3))
#d <- duplicated(rdam$WK_CODE)
#rdam$WK_CODE <- paste0(rdam$WK_CODE, ifelse(d, "B", "A"))
#rdam$fn <- sprintf("%s - %s - %s.svg", rdam$WK_CODE, rdam$GM_NAAM, rdam$WK_NAAM)

# Determine appropriate scale
dims <- sapply(rdam$geometry, function(x) {
  bb <- as.numeric(st_bbox(x))
  c(abs(bb[3]-bb[1]), abs(bb[4]-bb[2]))
})
dims <- t(dims)
# Ignore harbours for now; these are very long; using these to scale the map
# creates a very small map
excl <- which(rdam$WK_NAAM == "Botlek-Europoort-Maasvlakte")
# Print area is approx 200mm
max_size <- 205 # mm
scale    <- max_size/max(dims[-excl,])
scale    <- floor(scale*1000)/1000
scale
# Look at sizes of objects
dims*scale
# How large will the complete map be:
message("Total dimension")
bb <- as.numeric(st_bbox(rdam))
print(c(abs(bb[3]-bb[1]), abs(bb[4]-bb[2])) * scale)


# Create output dir
outdir <- "data_output"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)


# Create svg file for geometry of each district
svg_files <- character(0)
for (i in seq_len(nrow(rdam))) {
  message("Processing '", rdam$WK_NAAM[i], "'.")
  # Each district can consists of multiple separate polygons; loop over these
  for (j in seq_along(rdam$geometry[[i]])) {
    coords <- rdam$geometry[[i]][[j]]
    # One path can consist of multiple parts; these are usually holes in that 
    # case coords is a list.
    if (is.list(coords)) {
      coords <- lapply(coords, function(coords) {
          coords[,1] <- (coords[,1]-mean(coords[,1]))*scale
        coords[,2] <- (coords[,2]-mean(coords[,2]))*scale
        round(coords,2)
      })
      path <- sapply(coords, function(coords) {
        paste("M", paste(coords[,1], coords[,2]*-1, sep=",", collapse=" "), "Z")
      })
      path <- paste(path, collapse=" ")
    } else {
       path <- paste("M",
         paste(coords[,1], coords[,2]*-1, sep=",", collapse=" "), "Z")
    }
    # Write svg file
    fn <- sprintf("%s%s - %s - %s.svg", rdam$WK_CODE[i], LETTERS[j],
      rdam$GM_NAAM[i], rdam$WK_NAAM[i])
    message("  - '", fn, "'.")
    svg <- sprintf('<svg xmlns="http://www.w3.org/2000/svg">
      <path d="%s" />
    </svg>', path)
    writeLines(svg, file.path(outdir, fn))
    svg_files <- c(svg_files, fn)
  }
}

# Convert each svg file to a light box
for (fn in svg_files) {
  message("Converting '", fn, "' to STL format for light box.")
  ofn <- gsub("\\.svg$", "\\.stl", fn)
  cmd <- sprintf("openscad -D 'filename=\"%s\"' -o \"%s\" extrude_wijk.scad",
    file.path(outdir, fn), file.path(outdir, ofn))
  system(cmd)
}

# Second version in which we set padding to 0. Some objects have walls that
# are too thin; in those cases the version without padding might help
for (fn in svg_files) {
  message("Converting '", fn, "' to STL format for light box.")
  ofn <- gsub("\\.svg$", "_nopad\\.stl", fn)
  cmd <- sprintf("openscad -D 'filename=\"%s\"' -D 'padding=0' -o \"%s\" extrude_wijk.scad",
    file.path(outdir, fn), file.path(outdir, ofn))
  system(cmd)
}


# Convert each svg file to a cover
for (fn in svg_files) {
  message("Converting '", fn, "' to STL format for cover.")
  ofn <- gsub("\\.svg$", "_cover\\.stl", fn)
  cmd <- sprintf("openscad -D 'filename=\"%s\"' -o \"%s\" cover.scad",
    file.path(outdir, fn), file.path(outdir, ofn))
  system(cmd)
}


# Convert each svg file to a cover
# Second version in which we set padding to 0. Some objects have walls that
# are too thin; in those cases the version without padding might help
for (fn in svg_files) {
  message("Converting '", fn, "' to STL format for cover.")
  ofn <- gsub("\\.svg$", "_cover_nopad\\.stl", fn)
  cmd <- sprintf("openscad -D 'filename=\"%s\"' -D 'padding=0' -o \"%s\" cover.scad",
    file.path(outdir, fn), file.path(outdir, ofn))
  system(cmd)
}


# Convert each svg file to a cover
# Third version with extra padding
for (fn in svg_files) {
  message("Converting '", fn, "' to STL format for cover.")
  ofn <- gsub("\\.svg$", "_cover_extrapad\\.stl", fn)
  cmd <- sprintf("openscad -D 'filename=\"%s\"' -D 'padding_cover=0.4' -o \"%s\" cover.scad",
    file.path(outdir, fn), file.path(outdir, ofn))
  system(cmd)
}


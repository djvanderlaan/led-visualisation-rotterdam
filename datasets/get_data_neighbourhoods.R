library(cbsodataR)
library(data.table)
library(sf)

tableid <- "84799NED"

meta <- cbs_get_meta(tableid)
meta
meta$DataProperties$Title

# Get data from StatLine
dta <- cbs_get_data(tableid)
setDT(dta)

# Remove unnessary variables
dta[, MeestVoorkomendePostcode_113 := NULL]
dta[, Dekkingspercentage_114 := NULL]

# Remove spaces around values "bla   " -> "bla"
for (i in names(dta)) {
  if (is.factor(dta[[i]])) {
    levels(dta[[i]]) <- gsub("[ ]*$", "", levels(dta[[i]]))
  } else if (is.character(dta[[i]])) {
    dta[[i]] <- gsub("[ ]*$", "", dta[[i]])
  }
}

# Convert numerical values to numeric
for (i in names(dta)[-(1:4)]) {
  dta[[i]] <- as.numeric(dta[[i]])
}

# Remove variables without any data
all_missing <- sapply(dta, function(x) all(is.na(x)))
keep <- which(!all_missing)
dta <- dta[, ..keep]

# Only select "wijken" (districts)
dta <- dta[SoortRegio_2 == "Wijk"]

# Read the simplified map and add to dta
map <- st_read("data/wijk_2020_simplified.topojson")
map$geometry <- NULL
map$id <- NULL

dta <- merge(map, dta, by.x = "WK_CODE", by.y = "Codering_3", all = TRUE)

# And save
fwrite(dta, "data/wijken_2020_data.csv", row.names = FALSE)


library(cbsodataR)
library(data.table)
library(sf)

tableid <- "85163NED"

meta <- cbs_get_meta(tableid)
meta
meta$DataProperties$Title

# Get data from StatLine
dta <- cbs_get_data(tableid)
setDT(dta)

# Remove unnessary variables
keep <- c("WijkenEnBuurten", "Perioden", "GemiddeldeScore_29", "Waarde_37")
dta <- dta[, ..keep]

# Remove spaces around values "bla   " -> "bla"
for (i in names(dta)) {
  if (is.factor(dta[[i]])) {
    levels(dta[[i]]) <- gsub("[ ]*$", "", levels(dta[[i]]))
  } else if (is.character(dta[[i]])) {
    dta[[i]] <- gsub("[ ]*$", "", dta[[i]])
  }
}

# Convert jaar to numeric
dta[, Perioden := as.integer(substr(Perioden, 1, 4))]

# Convert numerical values to numeric
for (i in names(dta)[-(1:3)]) {
  dta[[i]] <- as.numeric(dta[[i]])
}

# Remove variables without any data
all_missing <- sapply(dta, function(x) all(is.na(x)))
keep <- which(!all_missing)
dta <- dta[, ..keep]

# Only select "wijken" (districts)
dta <- dta[substr(WijkenEnBuurten, 1, 2) == "WK"]

# Variablenames
setnames(dta, "GemiddeldeScore_29", "SES")
setnames(dta, "Waarde_37", "SES_MAD")
setnames(dta, "Perioden", "year")
setnames(dta, "WijkenEnBuurten", "WK_CODE")


# Calculate development in SES scores from 2014 to 2019
tmp <- dta[year %in% c(2014, 2019)] 
setorder(tmp, WK_CODE, year)
tmp <- tmp[, .(SES_change = diff(SES), SES_MAD_change = diff(SES_MAD)), 
  by = WK_CODE]
dta <- merge(dta[year == 2019], tmp, by = "WK_CODE", all.x = TRUE)

# Read the simplified map and add to dta
map <- st_read("data/wijk_2020_simplified.topojson")
map$geometry <- NULL
map$id <- NULL

dta <- merge(map, dta, by.x = "WK_CODE", by.y = "WK_CODE", all.x = TRUE)

# And save
fwrite(dta, "data/wijken_2019_ses.csv", row.names = FALSE)


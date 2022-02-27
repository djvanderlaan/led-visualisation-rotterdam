library(data.table)
library(sf)


pals <- c("Viridis", "Plasma", "Sunset", "SunsetDark", "ag_GrnYl", "Zissou 1")
pal_name <- pals[2]
ncol <- 7
pal <- hcl.colors(ncol, pal_name)
col_na <- "#101010"
pal <- c(pal, col_na)

# =============================================================================
dta <- fread("data/wijken_2020_data.csv")
# Only select Rotterdam
dta <- dta[dta$GM_NAAM == "Rotterdam", ]


# =============================================================================
# In order to be able to plot variables in a chloropleth map; the variables 
# need to be relative (dimensionless). Depending on the variable we have to
# normalise either by area, population or the number of households.
var_area <- "OppervlakteLand_111"
var_pop  <- "AantalInwoners_5"
var_hh   <- "HuishoudensTotaal_28"

# Function to perform the normalisation
make_relative <- function(dta, var, norm = c("No", "Area", "Pop", "HH")) {
  norm <- match.arg(norm)
  x <- dta[[var]]
  if (norm == "Area")  {
    dta[[var]] <- dta[[var]]/dta[[var_area]]
  } else if (norm == "Pop") {
    dta[[var]] <- dta[[var]]/dta[[var_pop]]
  } else if (norm == "HH") {
    dta[[var]] <- dta[[var]]/dta[[var_hh]]
  }
  dta
}

# Derive possible variables of interest
dta <- make_relative(dta, "HuurwoningenTotaal_41", "No")
dta <- make_relative(dta, "BouwjaarVoor2000_45", "No")
dta <- make_relative(dta, "BedrijfsvestigingenTotaal_91", "Area")
dta <- make_relative(dta, "RUCultuurRecreatieOverigeDiensten_98", "Area")
dta <- make_relative(dta, "PersonenautoSTotaal_99", "Pop")
dta <- make_relative(dta, "PercentageBewoond_38", "No")
dta <- make_relative(dta, "GemiddeldeHuishoudensgrootte_32", "No")
dta <- make_relative(dta, "Eenpersoonshuishoudens_29", "HH")
dta <- make_relative(dta, "PercentageEengezinswoning_36", "No")
dta <- make_relative(dta, "Omgevingsadressendichtheid_116", "No")
dta$jongeren <- 100*(dta$k_0Tot15Jaar_8 + dta$k_15Tot25Jaar_9)/dta$AantalInwoners_5
dta <- make_relative(dta, "jongeren", "No")
totopl <- (dta$OpleidingsniveauLaag_64 + dta$OpleidingsniveauMiddelbaar_65 + dta$OpleidingsniveauHoog_66)
dta$OpleidingsniveauLaag_64 <- 100*dta$OpleidingsniveauLaag_64/totopl
dta$OpleidingsniveauMiddelbaar_65 <- 100*dta$OpleidingsniveauMiddelbaar_65/totopl
dta$OpleidingsniveauHoog_66 <- 100*dta$OpleidingsniveauHoog_66/totopl


# =============================================================================
# Helper function to plot the data in a map
example_map <- function(dta, cat, pal_name = "Plasma") {
  pal <- hcl.colors(ncol, pal_name)
  col_na <- "#101010"
  pal <- c(pal, col_na)
  col <- pal[cat]
  col[is.na(col)] <- pal[ncol+1]
  map <- st_read("data/wijk_2020_simplified.topojson")
  dta <- merge(map, dta, by = "WK_CODE", suffixes = c(".x", ""), all.y = TRUE)
  par(mar = c(0,0,0,0)+0.1)
  plot(dta$geometry, border ="white", col = col)
  coords <- st_coordinates(st_centroid(dta$geometry))
  text(coords[,1], coords[,2], dta$WK_NAAM, cex = 0.5)
}

# =============================================================================
# Table with mapping from neighbourhoods on LEDS (some neighbourhoods can also
# have multiple LEDs)
mapping <- fread("data/mapping_op_leds.csv")

# VAR
var <- "HuurwoningenTotaal_41"
breaks <- quantile(dta[[var]], seq(0, 1, length.out = ncol+1), na.rm = TRUE)
breaks <- unique(breaks)
breaks <- c(0, 45, 55, 60, 65, 70, 75, 100)
cat <- as.numeric(cut(dta[[var]], breaks))
cat[is.na(cat)] <- ncol+1
# Print data for arduino
m <- match(mapping$wk_code, dta$WK_CODE)
m <- cat-1 + mapping$brightness*length(pal)
writeLines(c(
  paste0("// var: ", var),
  paste0("// breaks: ", paste0(breaks, collapse=", ")),
  paste0(m, collapse = ", ")))
# example map
example_map(dta, cat)


# VAR
var <- "BedrijfsvestigingenTotaal_91"
breaks <- quantile(dta[[var]], seq(0, 1, length.out = ncol+1), na.rm = TRUE)
breaks <- unique(breaks)
breaks <- c( 1,  2,  3,  4,  5,  6,  7,  8)
breaks <- c( 0,  1,  2,  4,  6, 10, 20, 25)
#breaks <- c(0, 45, 55, 60, 65, 70, 75, 100)
cat <- as.numeric(cut(dta[[var]], breaks))
cat[is.na(cat)] <- ncol+1
# Print data for arduino
m <- match(mapping$wk_code, dta$WK_CODE)
m <- cat-1 + mapping$brightness*length(pal)
writeLines(c(
  paste0("// var: ", var),
  paste0("// breaks: ", paste0(breaks, collapse=", ")),
  paste0(m, collapse = ", ")))
# example map
example_map(dta, cat)

# VAR
var <- "RUCultuurRecreatieOverigeDiensten_98"
breaks <- quantile(dta[[var]], seq(0, 1, length.out = ncol+1), na.rm = TRUE)
breaks <- unique(breaks)
breaks <- c( 1,  2,   3,  4,  5,  6,  7,  8)
breaks <- c( 0,0.1, 0.2,0.4,0.6,  1,  2,  5)
#breaks <- c(0, 45, 55, 60, 65, 70, 75, 100)
cat <- as.numeric(cut(dta[[var]], breaks))
cat[is.na(cat)] <- ncol+1
# Print data for arduino
m <- match(mapping$wk_code, dta$WK_CODE)
m <- cat-1 + mapping$brightness*length(pal)
writeLines(c(
  paste0("// var: ", var),
  paste0("// breaks: ", paste0(breaks, collapse=", ")),
  paste0(m, collapse = ", ")))
# example map
example_map(dta, cat)

# VAR
var <- "OpleidingsniveauHoog_66"
breaks <- quantile(dta[[var]], seq(0, 1, length.out = ncol+1), na.rm = TRUE)
breaks <- unique(breaks)
breaks <- c(0, 15, 20, 25, 30, 40, 50, 100)
breaks <- seq(8, 50, length.out = ncol+1)
breaks[1] <- 0
breaks[8] <- 100
cat <- as.numeric(cut(dta[[var]], breaks))
cat[is.na(cat)] <- ncol+1
# Print data for arduino
m <- match(mapping$wk_code, dta$WK_CODE)
m <- cat[m]-1 + mapping$brightness*length(pal)
writeLines(c(
  paste0("// var: ", var),
  paste0("// breaks: ", paste0(breaks, collapse=", ")),
  paste0(m, collapse = ", ")))
# example map
example_map(dta, cat)

# VAR
var <- "OpleidingsniveauLaag_64"
breaks <- quantile(dta[[var]], seq(0, 1, length.out = ncol+1), na.rm = TRUE)
breaks <- unique(breaks)
breaks
breaks <- c(0, 15, 20, 25, 30, 40, 50, 100)
breaks <- c(0, 15, 20, 24, 28, 32, 36, 100)
breaks <- seq(min(dta[[var]], na.rm=TRUE)-1, max(dta[[var]], na.rm = TRUE)+1, length.out = 8)
breaks <- seq(2, 44, length.out = 8)
breaks[1] <- 0
breaks[8] <- 100
cat <- as.numeric(cut(dta[[var]], breaks))
cat[is.na(cat)] <- ncol+1
# Print data for arduino
m <- match(mapping$wk_code, dta$WK_CODE)
m <- cat-1 + mapping$brightness*length(pal)
writeLines(c(
  paste0("// var: ", var),
  paste0("// breaks: ", paste0(breaks, collapse=", ")),
  paste0(m, collapse = ", ")))
# example map
example_map(dta, cat)

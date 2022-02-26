library(data.table)


pals <- c("Viridis", "Plasma", "Sunset", "SunsetDark", "ag_GrnYl", "Zissou 1")

pal_name <- pals[6]
ncol <- 7
pal <- hcl.colors(ncol, pal_name)


# =============================================================================
dta <- fread("data/wijken_2020_data.csv")
# Only select Rotterdam
dta <- dta[dta$GM_NAAM == "Rotterdam", ]


var_area <- "OppervlakteLand_111"
var_pop <- "AantalInwoners_5"
var_hh <- "HuishoudensTotaal_28"

var <- "HuurwoningenTotaal_41"
norm <- c("No", "Area", "Pop")[1]

var <- "BouwjaarVoor2000_45"
norm <- c("No", "Area", "Pop")[1]

var <- "BedrijfsvestigingenTotaal_91"
norm <- c("No", "Area", "Pop")[2]

var <- "PersonenautoSTotaal_99"
norm <- c("No", "Area", "Pop")[3]

var <- "PercentageBewoond_38"
norm <- c("No", "Area", "Pop")[1]

var <- "GemiddeldeHuishoudensgrootte_32"
norm <- "No"

var <- "Eenpersoonshuishoudens_29"
norm <- "HH"

var <- "PercentageEengezinswoning_36"
norm <- "No"

var <- "Omgevingsadressendichtheid_116"
norm <- "No"

dta$jongeren <- 100*(dta$k_0Tot15Jaar_8 + dta$k_15Tot25Jaar_9)/dta$AantalInwoners_5
var <- "jongeren"
norm <- "No"



x <- dta[[var]]
if (norm == "Area")  {
  x <- x / dta[[var_area]]
} else if (norm == "Pop") {
  x <- x / dta[[var_pop]]
} else if (norm == "HH") {
  x <- x / dta[[var_hh]]
}


breaks <- quantile(x, seq(0, 1, length.out = ncol+1), na.rm = TRUE)
breaks <- unique(breaks)
col <- pal[cut(x, breaks)]
col[is.na(col)] <- pal[ncol+1]

#par(mar = c(0,0,0,0)+0.1)
#plot(dta$geometry, border ="white", col = col)

#coords <- st_coordinates(st_centroid(dta))
#text(coords[,1], coords[,2], dta$WK_NAAM, cex = 0.5)



mapping <- fread("data/mapping_op_leds.csv")
m <- match(mapping$wk_code, dta$WK_CODE)
m <- match(col[m], pal)-1 + mapping$brightness*length(pal)
paste0(m, collapse = ", ")



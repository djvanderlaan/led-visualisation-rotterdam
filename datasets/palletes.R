pals <- c("Viridis", "Plasma", "Sunset", "SunsetDark", "Fall", "Zissou 1")
ncol <- 7

gamma <- c(1.8, 1.8, 2)
all_lines <- character(0)

for (i in seq_along(pals)) {
pal_name <- pals[i]
pal <- hcl.colors(ncol, pal_name)
col_na <- "#101010"
pal <- c(pal, col_na)
rgb <- col2rgb(pal)
rgb[1,] <- round((rgb[1,]/255)^gamma[1]*255)
rgb[2,] <- round((rgb[2,]/255)^gamma[2]*255)
rgb[3,] <- round((rgb[3,]/255)^gamma[3]*255)
lines <- character(ncol)
for (i in seq_len(ncol+1)) {
  lines[i] <- sprintf("0x%02X, 0x%02X, 0x%02X, 0x%02X",
    255, 
    round(factors[3]*rgb[3, i]), 
    round(factors[2]*rgb[2,i]), 
    round(factors[1]*rgb[1,i]))
}
lines_brightness1 <- character(ncol)
brightness1_factor <- 0.4
for (i in seq_len(ncol+1)) {
  lines_brightness1[i] <- sprintf("0x%02X, 0x%02X, 0x%02X, 0x%02X",
    255, 
    round(factors[3]*rgb[3, i]*brightness1_factor),
    round(factors[2]*rgb[2,i]*brightness1_factor), 
    round(factors[1]*rgb[1,i]*brightness1_factor))
}
all_lines <- c(all_lines, sprintf("//%s", pal_name), lines, lines_brightness1)
}
writeLines(paste0(all_lines, collapse=",\n"))

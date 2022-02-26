pals <- c("Viridis", "Plasma", "Sunset", "SunsetDark", "ag_GrnYl", "Zissou 1")
ncol <- 7

lapply(pals, function(pal_name) {
pal_name <- pals[6]
pal <- hcl.colors(ncol, pal_name)
col_na <- "#101010"
pal <- c(pal, col_na)
rgb <- col2rgb(pal)
lines <- character(ncol)
for (i in seq_len(ncol+1)) {
  lines[i] <- sprintf("0x%02X, 0x%02X, 0x%02X, 0x%02X",
    255, round(0.9*rgb[3, i]), round(0.9*rgb[2,i]), round(0.8*rgb[1,i]))
}
lines_brightness1 <- character(ncol)
brightness1_factor <- 0.4
for (i in seq_len(ncol+1)) {
  lines_brightness1[i] <- sprintf("0x%02X, 0x%02X, 0x%02X, 0x%02X",
    255, 
    round(0.9*rgb[3, i]*brightness1_factor),
    round(0.9*rgb[2,i]*brightness1_factor), 
    round(0.8*rgb[1,i]*brightness1_factor))
}
lines <- c(sprintf("//%s", pal_name), lines, lines_brightness1)
lines
}

writeLines(paste0(c(sprintf("//%s", pal_name), lines, lines_brightness1), collapse=",\n"))


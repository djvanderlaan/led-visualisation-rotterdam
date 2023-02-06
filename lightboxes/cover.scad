
filename = "data_output/WK059921A - Rotterdam - Waalhaven-Eemhaven.svg";

wall_thickness = 0.8;
padding = 0.5;
padding_cover = 0.05;

module map(height = 25, offset = 0) {
  linear_extrude(height)
    offset(delta  = -offset)
    import(filename);
}


map(height = 4, offset = padding + wall_thickness + padding_cover);
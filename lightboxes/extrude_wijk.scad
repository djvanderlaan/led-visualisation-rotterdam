//import("data_output/WK059901A - Rotterdam - Rotterdam Centrum.svg");

filename = "data_output/WK059921A - Rotterdam - Waalhaven-Eemhaven.svg";

wall_thickness = 0.8;
padding = 0.5;

module map(height = 25, offset = 0) {
  linear_extrude(height)
    offset(delta  = -offset)
    import(filename);
}

module grid(height = 100) {
  for (i = [-25:25]) {
    translate([-100, -i*10, 0])
      cube([200, wall_thickness, height]);
    translate([-i*10, -100, 0])
      cube([wall_thickness, 200, height]);
  }  
}

//module grid(height = 25) {
//  for (i = [-10:10]) {
//    for (j = [-10:10]) {
//      translate([j*10, i*10, 0])
//        cylinder(h = height, r = 1);
//    }
//  }  
//}




difference(){
  intersection() {
    grid(height = 25-2);
    map(offset = padding);
  }
  map(height = 25, offset = padding + 3);
}

difference(){
  map(height = 25, offset = padding);
  translate([0, 0, wall_thickness])
  map(height = 25, offset = padding + wall_thickness);
}

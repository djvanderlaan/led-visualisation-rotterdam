r = 30/2;
h = 10;
thickness = 0.5;

difference() {
difference() {
  cylinder(r1 = r, r2 = 0, h = r);
  translate([0, 0, h])
    cylinder(r = r, h = r);
}

difference() {
  cylinder(r1 = r-thickness, r2 = 0, h = r-thickness);
 translate([0, 0, h-thickness])
    cylinder(r = r, h = r);
}
}
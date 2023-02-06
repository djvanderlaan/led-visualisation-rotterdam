

strip_w = 12.2;
strip_d = 116/7;
nled    = 7;
d       = 2;
h       = 4;
d_cover = 4;
h_back  = 4;
d_card  = 2.5;

inside  = [strip_d*nled, strip_w+2*d];
outside = [inside[0]+1*d, inside[1]+2*d, h];

show_box   = true;
show_cover = false;

// ==================================================
// BOX

if (show_box) {
  difference() {
    cube(outside);
    // holes
    for (i = [1:nled]) {
      translate([d+(i-1)*strip_d, d, -h/2])
        cube([strip_d - d, inside[1], h*2]);
    }
  }
  // flanges at back
  translate([d, +d, -h_back+0.01])
    cube([inside[0]-d, d, h_back]);
  translate([d, outside[1]-2*d, -h_back+0.01])
    cube([inside[0]-d, d, h_back]);
  // sloped tops of flanges
  translate([d, 2*d, 0])
    rotate([180, 0, 0])
    rotate([0, 90, 0])
    linear_extrude(inside[0]-d)
    polygon(points = [[0, 0], [0, d], [d, d]]);
  translate([d, outside[1]-2*d, 0])
    mirror([0, 1, 0])
    rotate([180, 0, 0])
    rotate([0, 90, 0])
    linear_extrude(inside[0]-d)
    polygon(points = [[0, 0], [0, d], [d, d]]);
}


translate([0, -3, d_card])
cube([outside[0], 3, outside[2]-d_card]);





// ==================================================
// COVER
cover = [outside[0], outside[1], d_cover];


if (show_cover) {
  translate([0, 0, h+2])
    difference() {
      cube(cover);
      // holes at bottom of cover
      for (i = [0:nled]) {
        translate([i*strip_d-0.05, -outside[1]*0.5, -0.01])
          cube([d+0.1, outside[1]*2, d_cover*0.5]); 
      }
      // slits at top of cover
      for (i = [1:(nled-1)]) {
        translate([i*strip_d, -outside[1]*0.5, d_cover])
          translate([d/2, 0, d_cover*0.25-d_cover/5])
          rotate([0, 45, 0])
          translate([-d/2, 0, -d_cover*0.25])
          cube([d, outside[1]*2, d_cover*0.5]);
      }

      translate([-outside[0]/2, -0.05, -0.01])
        cube([outside[0]*2, d+0.1, d_cover*0.5]);
      translate([-outside[0]/2, outside[1]-d-0.05, -0.01])
        cube([outside[0]*2, d+0.1, d_cover*0.5]);
    }
  }  
  

//// ==================================================
//// BOX
//difference() {
//  union() {
//    cube(outside);
//    // flanges at back
//    translate([0, -d*2, -d])
//      cube([outside[0], d*3, d]);
//    translate([0, outside[1]-d, -d])
//      cube([outside[0], d*3, d]);
//  }
//  // holes
//  for (i = [1:nled]) {
//    translate([d+(i-1)*strip_d, d, -h/2])
//      cube([strip_d - d, strip_w, h*2]);
//  }
//}
//
//// ==================================================
//// COVER
//cover = [outside[0], outside[1], d_cover];
//translate([0, 0, h+2])
//  difference() {
//    cube(cover);
//    // holes at bottom of cover
//    for (i = [0:nled]) {
//      translate([i*strip_d-0.05, -outside[1]*0.5, -0.01])
//        cube([d+0.1, outside[1]*2, d_cover*0.5]); 
//    }
//    // slits at top of cover
//    for (i = [1:(nled-1)]) {
//      translate([i*strip_d, -outside[1]*0.5, d_cover])
//        translate([d/2, 0, d_cover*0.25-d_cover/5])
//        rotate([0, 45, 0])
//        translate([-d/2, 0, -d_cover*0.25])
//        cube([d, outside[1]*2, d_cover*0.5]);
//    }
//
//    translate([-outside[0]/2, -0.05, -0.01])
//      cube([outside[0]*2, d+0.1, d_cover*0.5]);
//    translate([-outside[0]/2, outside[1]-d-0.05, -0.01])
//      cube([outside[0]*2, d+0.1, d_cover*0.5]);
//  }
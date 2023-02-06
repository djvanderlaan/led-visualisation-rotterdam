
$fn = 100;

d = 2.54;


module led() {
    r = 5/2;
    h = 6;
    hcyl = h - r;
    color("white")
    translate([0, 0, h - r])
        sphere(r = r);
    color("white")
    cylinder(h = h - r , r = r);
    color("gray")
    translate([-d/2, 0, -30+0.01])
        cylinder(h = 30, r = 0.5);
    color("gray")
    translate([d/2, 0, -30+0.01])
        cylinder(h = 30, r = 0.5);
}


module lsr() {
    cylinder(h = 2, r = 5/2);
    translate([-d/2, 0, -30+0.01])
        cylinder(h = 30, r = 0.5);
    translate([d/2, 0, -30+0.01])
        cylinder(h = 30, r = 0.5);
}


module perfboard(nx, ny) {
    difference() {
        cube([d*(nx+1), d*(ny+1), 2]);
        for (i = [1:nx]) {
            for (j = [1:ny]) {
                translate([d*i, d*j, -0.1])
                    cylinder(h = 2.2, r = 0.5);
            }
        }
    }
}



module reader_part() {
    //Base below the led and bottom plate
    //color("yellow")
    difference() {
        union() {
            cube([d*3, 2+6, 7]);
            cube([d*3, 7 + 3 + 7, 2]);
        }
        union() {
            translate([d*3/2-d/2, 3, -0.1])
                cylinder(r = 1, h = 2+6+0.2);
            translate([d*3/2+d/2, 3, -0.1])
                cylinder(r = 1, h = 2+6+0.2);
        }
    }
    // Opening in front of led
    //color("pink")
    translate([0, 6, 7-0.01])
    difference() {
        cube([d*3, 2, 3+4+5]);
        translate([d*3/2, 2.1, 2+3])
            rotate([90, 0, 0])
            cylinder(r = 6/2, h = 2.2);
    }
    // Side plate next to led
    //color("orange")
    translate([0, 0, 7-0.01])
        cube([1, 2+6, 3+4+5]);
    //color("lightgreen") {
    translate([0, 0, -3])
        cube([1, 7+3+7, 3]);
    translate([d*3-1, 0, -3])
        cube([1, 7+3+7, 3]);
    translate([d*3*0.5-0.5, 0, -3])
        cube([1, 7+3+7, 3]);
    translate([0, 0, -3])
        cube([d*3, 1, 3]);
    //}
    // The part containing the light sensitive resistor
    //color("green")
    difference() {
        translate([0, 7+3, 0])
            cube([d*3, 7, 3+4+5+7]);
        union() {
            translate([3*d/2, -0.1 + 7+3, 12])
                rotate([-90, 0, 0])
                cylinder(r=6/2, h = 5);
            translate([d*3/2-d/2, -0.1 + 7 + 3, 12])
                rotate([-90, 0, 0])
                cylinder(r = 1, h = 2+6+0.2);
            translate([d*3/2+d/2, -0.1 + 7 + 3, 12])
                rotate([-90, 0, 0])
                cylinder(r = 1, h = 2+6+0.2);
        }
    }
}


if (false) {
reader_part();
translate([3*d, 0, 0]) reader_part();
translate([3*d*2, 0, 0]) reader_part();
}

// ==============================================================
// CARD
//color("gray") {
//translate([0, 8.25, 2.0]) 
//
//  difference() {
//  cube([150, 0.8, 210]);
//    
//    translate([d*1.5, -1, 10])
//      rotate([-90, 0, 0])
//      cylinder(r = 1.5, h = 5);
//    translate([d*3+d*1.5, -1.2, 10])
//      rotate([-90, 0, 0])
//      cylinder(r = 1.5, h = 1.5);
//    translate([d*6+d*1.5, -1.2, 10])
//      rotate([-90, 0, 0])
//      cylinder(r = 1.5, h = 1.5);
//  }
//}

//// Example light sensitive resistor
//translate([3*d*0, 0, 0])
//    translate([3*d/2, 7+3+5-1, 12])
//    rotate([90, 0, 0])
//    lsr();
//translate([3*d*1, 0, 0])
//    translate([3*d/2, 7+3+5-1, 12])
//    rotate([90, 0, 0])
//    lsr();
//translate([3*d*2, 0, 0])
//    translate([3*d/2, 7+3+5-1, 12])
//    rotate([90, 0, 0])
//    lsr();
//
//translate([3*d*0, 0, 0])
//    translate([d*3/2, 3, 7.5]) led();
//translate([3*d, 0, 0])
//    translate([d*3/2, 3, 7.5]) led();
//translate([3*d*2, 0, 0])
//    translate([d*3/2, 3, 7.5]) led();
//
//color("darkgreen")
//
//translate([0, 7+3+7+1, 12+3*d])
//    rotate([-90, 0, 0])
//    perfboard(10, 10);



// =============================================================
// COVER
cover_padding = 1;
  cover_thickness = 2;
if (true) {
  
  translate([0, 0, -3]) {
    difference() {
      translate([-cover_thickness, -cover_thickness, -cover_thickness]) {
        cube([9*d+2*cover_thickness+cover_padding, 7+3+cover_thickness, 
          3+4+5+7+3+2*cover_thickness+cover_padding]);
        translate([-15, 7, -15])
        cube([9*d+2*cover_thickness+cover_padding+15, 3+cover_thickness, 
          3+4+5+7+3+2*cover_thickness+cover_padding+15]);
      }
      union() {
        cube([9*d+cover_padding, 7+3, 3+4+5+7+3+cover_padding]);
        translate([0, 7+1, 5])
          cube([100,2, 100]);
      
        translate([-15+2, 0, 12]) {
          rotate([-90, 0, 0])
          cylinder(r = 6/2, h = 7-cover_thickness+2);
          rotate([-90, 0, 0])
          cylinder(r = 3/2, h = 7-cover_thickness+20);
        }
        translate([12, 0, -15+2]) {
          rotate([-90, 0, 0])
          cylinder(r = 6/2, h = 7-cover_thickness+2);
          rotate([-90, 0, 0])
          cylinder(r = 3/2, h = 7-cover_thickness+20);
        }
      }
    }
  }
//  // flange with hole for screw
//  translate([0, 0, -3-(5+1+cover_thickness+4)]) {
//    difference() {
//      translate([-cover_thickness, 7-cover_thickness, -cover_thickness])
//        cube([9*d+2*cover_thickness+cover_padding, 3+cover_thickness, 5+5+cover_thickness]);
//      union() {
//        translate([9*d/2, 0, 2])
//          rotate([-90, 0, 0])
//          cylinder(r = 6/2, h = 7-cover_thickness+2);
//        translate([9*d/2, 0, 2])
//          rotate([-90, 0, 0])
//          cylinder(r = 3/2, h = 7-cover_thickness+20);
//      }
//    }
//  }
//  
//  // flange with hole for screw
//  translate([0, 0, -3-(5+5+cover_thickness)]) {
//    difference() {
//      translate([-cover_thickness, 7-cover_thickness, -cover_thickness])
//        cube([9*d+2*cover_thickness+cover_padding, 3+cover_thickness, 5+5+cover_thickness]);
//      union() {
//        translate([9*d/2, 0, 2])
//          rotate([-90, 0, 0])
//          cylinder(r = 6/2, h = 7-cover_thickness+2);
//        translate([9*d/2, 0, 2])
//          rotate([-90, 0, 0])
//          cylinder(r = 3/2, h = 7-cover_thickness+20);
//      }
//    }
//  }
}


// =============================================================
// GUIDE
if (false) {
  translate([0, 0, -3]) {
    difference() {
      translate([0, 7-cover_thickness, -cover_thickness])
        cube([9*d, 3+cover_thickness, 5+4+cover_thickness]);
      union() {
        translate([-0.1, 7+1, 5])
          cube([100,2, 100]);
        translate([9*d/2, 0, 2])
      rotate([-90, 0, 0])
      cylinder(r = 6/2, h = 7-cover_thickness+2);
    translate([9*d/2, 0, 2])
      rotate([-90, 0, 0])
      cylinder(r = 3/2, h = 7-cover_thickness+20);
      }
    }
   
  }
}





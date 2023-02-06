
dim = [19,50];
thickness = 8;
width = 15;
front =  20;
edge = 10;

cube([dim[1], thickness, width]);

cube([thickness, 2*thickness+dim[0], width]);

translate([0, dim[0]+thickness, 0])
  cube([dim[1]+thickness, thickness, width]);


translate([dim[1], dim[0]+thickness, 0])
  cube([thickness, 2*thickness+front, width]);

translate([dim[1]-edge, dim[0]+2*thickness+front, 0])
  cube([edge+thickness, thickness, width]);
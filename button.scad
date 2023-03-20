/* Simple button attachment */

$fn = 50;

mode = "base"; // ["cap", "base", "all"]
tolerance = 0.4;

base_width = 6;
base_depth = 6;
base_height= 3;
button_diameter = 3.4;
button_height = 2;

movement = 0.4;


module button() {
  translate([0,0,-0.001]) {
    union() {
      translate([-base_width/2, -base_depth/2, 0])
        cube([base_width,base_depth,base_height]);
      translate([0,0,base_height - 0.001])
        cylinder(h=button_height,r=button_diameter/2);
    }
  }
}
if (mode == "cap" || mode == "all") {
  union() {
    cylinder(h=5, r=3.5);
    cylinder(h=.5, r=5);
  }
 }
if (mode == "base" || mode == "all") {
  translate([0,0,-2.5])
  difference() {
    union() {
      translate([-15, -.5, -3.1])
        cube([30, 1, 6.1]);
      translate([-3.75, -3.75, -3.1])
        cube([7.5,7.5,6.1]);
      translate([12,0,-3.1])
        cylinder(h=6.1,r=3);
      translate([-12,0,-3.1])
        cylinder(h=6.1,r=3);
    }
    translate([-3.25, -3.25, -2.101])
      cube([6.5, 6.5, 5]);
    translate([0,0,2])
    cylinder(h=1.01, r=5.5);
    translate([0.5,0.5,-3.2])
      cube([2.75,2.75,5]);
    translate([-3.25,0.5,-3.2])
      cube([2.75,2.75,5]);
    translate([0.5,-3.25,-3.2])
      cube([2.75,2.75,5]);
    translate([-3.25,-3.25,-3.2])
      cube([2.75,2.75,5]);
  }
 }

if (mode == "all") {
  translate([0,0,-4.6])
    color("gray")
    button();
}

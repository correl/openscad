/* Project box

A parametric box for perforated circuit boards. The board is held above the
bottom of the box by four corner supports, and snaps into place to hold it
snugly while allowing easy removal.
*/

$fn=50;

board_x = 50;
board_y = 70;
board_thickness = 1; // [1:10]
clearance_above = 20; // [5:50]
clearance_below = 10; // [5:50]
fit_tolerance = 0.5;
corner_radius=3; // [1:10]
support_radius=5; // [1:10]
wall_width=3; // [3:10]

module _rounded_box(h, w, d, r) {
  hull() {
    translate([0 + r,0 + r,0])
      cylinder(h=h,r=r);
    translate([w - r,0 + r,0])
      cylinder(h=h, r=r);
    translate([w - r,d - r,0])
      cylinder(h=h, r=r);
    translate([0 + r,d - r,0])
      cylinder(h=h, r=r);
  }

}

module corner_post(h, r) {
  intersection() {
    translate([-0.001,-0.001,-0.001])
      cube([r*1.1, r*1.1, h*1.2]);
    cylinder(h=h, r=r);
  }
}

module project_box(x, y,
                   above=20,
                   below=10,
                   board_thickness=1,
                   fit_tolerance=0.5,
                   corner_radius=3,
                   support_radius=5,
                   wall_width=3) {
  height=board_thickness + above + below + (fit_tolerance * 2);
  width=board_x + (fit_tolerance * 2);
  depth=board_y + (fit_tolerance * 2);

  // container
  difference() {
    _rounded_box(h=height + (wall_width * 2),
                 w=width + (wall_width * 2),
                 d=depth + (wall_width * 2),
                 r=corner_radius);
    translate([wall_width,wall_width,wall_width])
      cube([width, depth, height + (wall_width * 2)]);
  }

  // supports
  translate([wall_width,wall_width,wall_width]) {
    translate([0,0,0])
      corner_post(h=below, r=support_radius);
    translate([width,0,0])
      rotate([0,0,90])
      corner_post(h=below, r=support_radius);
    translate([0,depth,0])
      rotate([0,0,270])
      corner_post(h=below, r=support_radius);
    translate([width,depth,0])
      rotate([0,0,180])
      corner_post(h=below, r=support_radius);
  }


  // locking nubs
  translate([wall_width,wall_width,wall_width]) {
    nub_size = 1;
    nub_width = board_y / 4;
    nub_height = below + board_thickness + (nub_size/2) + (fit_tolerance*2);
    translate([0,board_y / 2 - nub_width / 2,nub_height])
      rotate([270,0,0])
      cylinder(h=nub_width, r=1);
    translate([width,board_y / 2 - nub_width / 2,nub_height])
      rotate([270,0,0])
      cylinder(h=nub_width, r=1);
  }
}

project_box(board_x, board_y,
            above=clearance_above,
            below=clearance_below,
            board_thickness=board_thickness,
            fit_tolerance=fit_tolerance,
            corner_radius=corner_radius,
            support_radius=support_radius,
            wall_width=wall_width);

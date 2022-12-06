/* Project box

   A parametric box for electronics projects using perforated circuit boards. The
   board is held above the bottom of the box by four corner supports, and snaps
   into place to hold it snugly while allowing easy removal.
*/

$fn=50;

mode = "case";         // ["case", "lid", "all"]
board_x = 50;
board_y = 70;
board_thickness = 1;   // [1:10]
clearance_above = 20;  // [5:50]
clearance_below = 10;  // [5:50]
fit_tolerance = 0.5;
corner_radius=3;       // [1:10]
support_radius=5;      // [1:10]
wall_width=3;          // [3:10]

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

module lid_base(x, y, z, slot_depth=1.5) {
  polyhedron([// bottom face
              [0, 0, 0],
              [x, 0, 0],
              [x, y, 0],
              [0, y, 0],
              // top face
              [slot_depth, 0, z],
              [x - slot_depth, 0, z],
              [x - slot_depth, y, z],
              [slot_depth, y, z]],
             [[0,1,2,3],
              [4,5,1,0],
              [7,6,5,4],
              [5,6,2,1],
              [6,7,3,2],
              [7,4,0,3]]);
}

module lid(x, y, z, slot_depth=1.5, wall_width=3, fit_tolerance=0.5) {
  indent_width = x / 4;
  difference() {
    union() {
      lid_base(x, y, z, slot_depth);
      // locking tab
      translate([x / 2 - indent_width / 2 - fit_tolerance, y - wall_width - fit_tolerance, 0])
        rotate([0, 90, 0])
        cylinder(h=x / 4, r=2*fit_tolerance);
    }
    // pull handle
    translate([x / 2 - indent_width / 2 - fit_tolerance, y - (2 * fit_tolerance), 0])
      rotate([0, 90, 0])
      cylinder(h=x / 4, r=3*fit_tolerance);
  }
}

module project_box(x, y,
                   above=20,
                   below=10,
                   board_thickness=1,
                   fit_tolerance=0.5,
                   corner_radius=3,
                   support_radius=5,
                   wall_width=3,
                   mode="case") {
  width=board_x + (fit_tolerance * 2);
  depth=board_y + (fit_tolerance * 2);
  lid_width = width + wall_width; // Extends halfway into each side wall
  lid_depth = depth + wall_width; // Extends out of one wall
  lid_height = wall_width;        // Replaces most of the top wall
  height=board_thickness + above + below + (fit_tolerance * 2) + lid_height;

  // lid
  if (mode == "all") {
    translate([wall_width / 2 + fit_tolerance, wall_width + fit_tolerance, height + wall_width + fit_tolerance]) {
      lid(lid_width - (fit_tolerance * 2), lid_depth - (fit_tolerance * 2), lid_height - (fit_tolerance * 2));
    }
  } else if (mode == "lid") {
    // Flip the lid and translate it into place for printing
    translate([lid_width - (fit_tolerance * 2),0,lid_height - (fit_tolerance * 2)])
      rotate([0, 180, 0])
      lid(lid_width - (fit_tolerance * 2), lid_depth - (fit_tolerance * 2), lid_height - (fit_tolerance * 2));
  }

  // case
  if ((mode == "case") || (mode == "all")) {
    difference() {
      _rounded_box(h=height + (wall_width * 2),
                   w=width + (wall_width * 2),
                   d=depth + (wall_width * 2),
                   r=corner_radius);
      translate([wall_width,wall_width,wall_width])
        cube([width, depth, height + (wall_width * 2)]);
      // lid slot
      translate([wall_width / 2, wall_width, height + wall_width + 0.001]) {
        lid_base(lid_width, lid_depth, lid_height);
      }
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
      nub_size = fit_tolerance * 2;
      nub_width = board_y / 4;
      nub_height = below + board_thickness + (nub_size/2) + (fit_tolerance*2);
      translate([0,board_y / 2 - nub_width / 2,nub_height])
        rotate([270,0,0])
        cylinder(h=nub_width, r=nub_size/2);
      translate([width,board_y / 2 - nub_width / 2,nub_height])
        rotate([270,0,0])
        cylinder(h=nub_width, r=nub_size/2);
    }
  }
}

project_box(board_x, board_y,
            above=clearance_above,
            below=clearance_below,
            board_thickness=board_thickness,
            fit_tolerance=fit_tolerance,
            corner_radius=corner_radius,
            support_radius=support_radius,
            wall_width=wall_width,
            mode=mode);

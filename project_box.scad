/* Project box

   A parametric box for electronics projects using perforated circuit boards. The
   board is held above the bottom of the box by four corner supports, and snaps
   into place to hold it snugly while allowing easy removal.

   Shapes provided as children will be used as cutouts, translated to the origin
   point of the top of the circuit board. Modules are provided for cutting out
   two-dimensional shapes from each wall face as well as the lid.
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

module _rounded_box(box, r) {
  hull() {
    translate([0 + r,0 + r,0])
      cylinder(h=box.z,r=r);
    translate([box.x - r,0 + r,0])
      cylinder(h=box.z, r=r);
    translate([box.x - r,box.y - r,0])
      cylinder(h=box.z, r=r);
    translate([0 + r,box.y - r,0])
      cylinder(h=box.z, r=r);
  }
}

module corner_post(h, r) {
  intersection() {
    translate([-0.001,-0.001,-0.001])
      cube([r*1.1, r*1.1, h*1.2]);
    cylinder(h=h, r=r);
  }
}

module lid_base(dimensions, slot_depth=1.5) {
  polyhedron([// bottom face
              [0, 0, 0],
              [dimensions.x, 0, 0],
              [dimensions.x, dimensions.y, 0],
              [0, dimensions.y, 0],
              // top face
              [slot_depth, 0, dimensions.z],
              [dimensions.x - slot_depth, 0, dimensions.z],
              [dimensions.x - slot_depth, dimensions.y, dimensions.z],
              [slot_depth, dimensions.y, dimensions.z]],
             [[0,1,2,3],
              [4,5,1,0],
              [7,6,5,4],
              [5,6,2,1],
              [6,7,3,2],
              [7,4,0,3]]);
}

module lid(dimensions, slot_depth=1.5, wall_width=3, fit_tolerance=0.5) {
  indent_width = dimensions.x / 4;
  difference() {
    union() {
      lid_base([dimensions.x, dimensions.y, dimensions.z], slot_depth);
      // locking tab
      translate([dimensions.x / 2 - indent_width / 2 - fit_tolerance,
                 dimensions.y - wall_width - fit_tolerance,
                 0])
        rotate([0, 90, 0])
        cylinder(h=dimensions.x / 4, r=2*fit_tolerance);
    }
    // pull handle
    translate([dimensions.x / 2 - indent_width / 2 - fit_tolerance,
               dimensions.y - wall_width + fit_tolerance + 0.001,
               -0.001]) {
      cube([indent_width,wall_width - 2 * fit_tolerance,0.6 * dimensions.z]);
      cube([indent_width,2 + wall_width - 2 * fit_tolerance,0.3 * dimensions.z]);
    }
  }
}

module project_box(box,
                   below=10,
                   board_thickness=1,
                   fit_tolerance=0.5,
                   corner_radius=3,
                   support_radius=5,
                   wall_width=3,
                   mode="case") {
  internal_width = box.x + (fit_tolerance * 2);  // tolerance on either side
  internal_depth = box.y + (fit_tolerance * 2);  // tolerance on either side

  internal_height = (fit_tolerance      // top tolerance
                     + box.z            // project height
                     + board_thickness  // board height
                     + below            // bottom clearance
                     + fit_tolerance);  // bottom tolerance

  lid_width = internal_width + wall_width;  // Extends halfway into each side wall
  lid_depth = internal_depth + wall_width;  // Extends out of one wall
  lid_height = wall_width;         // Replaces most of the top wall

  // case
  if ((mode == "case") || (mode == "all")) {
    difference() {
      union() {
        // hollow shell
        difference() {
          _rounded_box([internal_width + (wall_width * 2),
                        internal_depth + (wall_width * 2),
                        internal_height + (wall_width * 2)],
                       r=corner_radius);
          translate([wall_width,wall_width,wall_width + 0.002])
            cube([internal_width, internal_depth, internal_height]);
          // lid slot
          translate([wall_width / 2, wall_width, internal_height + wall_width + 0.001]) {
            lid_base([lid_width, lid_depth, lid_height]);
          }
        }
        // supports
        translate([wall_width,wall_width,wall_width]) {
          translate([0,0,0])
            corner_post(h=below, r=support_radius);
          translate([internal_width, 0, 0])
            rotate([0,0,90])
            corner_post(h=below, r=support_radius);
          translate([0,internal_depth, 0])
            rotate([0,0,270])
            corner_post(h=below, r=support_radius);
          translate([internal_width, internal_depth, 0])
            rotate([0,0,180])
            corner_post(h=below, r=support_radius);
        }

        // locking nubs
        translate([wall_width,wall_width,wall_width]) {
          nub_size = fit_tolerance * 2;
          nub_width = box.y / 4;
          nub_height = below + board_thickness + (nub_size/2) + (fit_tolerance*2);
          translate([0,box.y / 2 - nub_width / 2,nub_height])
            rotate([270,0,0])
            cylinder(h=nub_width, r=nub_size/2);
          translate([internal_width,box.y / 2 - nub_width / 2,nub_height])
            rotate([270,0,0])
            cylinder(h=nub_width, r=nub_size/2);
        }
        if (mode == "all") {
          // lid
          translate([wall_width / 2 + fit_tolerance,
                     wall_width + fit_tolerance,
                     internal_height + wall_width + fit_tolerance]) {
            lid([lid_width - (fit_tolerance * 2),
                 lid_depth - (fit_tolerance * 2),
                 lid_height - (fit_tolerance * 2)]);
          }
        }
      }
      // cutouts
      translate([wall_width + fit_tolerance,
                 wall_width + fit_tolerance,
                 fit_tolerance + wall_width + below + board_thickness])
        children();
    }
  } else if (mode == "lid") {
    // Flip the lid and translate it into place for printing
    translate([lid_width - (fit_tolerance * 2),0,lid_height - (fit_tolerance * 2)]) {
      rotate([0, 180, 0]) {
        difference() {
          translate([wall_width / 2 + fit_tolerance,
                     wall_width + fit_tolerance, 0]) {
            lid([lid_width - (fit_tolerance * 2),
                 lid_depth - (fit_tolerance * 2),
                 lid_height - (fit_tolerance * 2)]);
          }
          translate([wall_width + fit_tolerance,
                     wall_width + fit_tolerance,
                     below + board_thickness - internal_height]) {
            #children();
          }
        }
      }
    }
  }
}

module cutout_front(box, wall_width=3, fit_tolerance=0.5) {
  rotate([90, 0, 0])
    linear_extrude(height=wall_width + fit_tolerance + 0.001)
    children(0);
}

module cutout_back(box, wall_width=3, fit_tolerance=0.5)  {
  translate([box.x,box.y,0])
    rotate([90, 0, 180])
    linear_extrude(height=wall_width + fit_tolerance + .001)
    children(0);
}

module cutout_right(box, wall_width=3, fit_tolerance=0.5) {
  translate([box.x,0,0])
    rotate([90, 0, 90])
    linear_extrude(height=wall_width + fit_tolerance + 0.001)
    children(0);
}

module cutout_left(box, wall_width=3, fit_tolerance=0.5) {
  translate([0, box.y, 0])
    rotate([90, 0, 270])
    linear_extrude(height=wall_width + fit_tolerance + 0.001)
    children(0);
}

module cutout_top(box, wall_width=3, fit_tolerance=0.5) {
  translate([0, 0 - wall_width - fit_tolerance, box.z])
    linear_extrude(height=wall_width + fit_tolerance + 0.001)
    children(0);
}

project_box([board_x, board_y, clearance_above],
            below=clearance_below,
            board_thickness=board_thickness,
            fit_tolerance=fit_tolerance,
            corner_radius=corner_radius,
            support_radius=support_radius,
            wall_width=wall_width,
            mode=mode);

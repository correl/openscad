/* Ducky Shine 6 USB-C Connector Housing

   For a Ducky Shine 6 keyboard, replaces the housing used for the factory USB
   Micro-B connector. Accommodates a 9mm x 14mm JRC-B008 USB-C breakout board.
*/

$fn = 50;

mode = "bottom"; // ["top", "bottom", "both"]

fit_tolerance = 0.4;
housing_width = 14;
housing_depth = 14;
housing_height = 6;
exposed_connector = 4;
cable_insert_length = 7.3;

module top() {
  translate([0,0,housing_height / 2])
    cube([housing_width, housing_depth, housing_height / 2]);
}

module bottom() {
  lip_width = 1.5;
  tab_depth = 6;
  left_tab_width = 5.5;
  right_tab_width = 7.3;
  screw_diameter = 3;

  // Left lip + tab
  cube([housing_width, housing_depth, housing_height / 2]);
  translate([-lip_width, 0, 0]) {
    cube([lip_width + fit_tolerance, housing_depth, housing_height / 4]);

    translate([-left_tab_width, housing_depth - 2 - tab_depth, 0]) {
      difference() {
        cube([1.5 + fit_tolerance + left_tab_width, tab_depth, housing_height / 4]);
        translate([3, 3, -1])
          cylinder(h=housing_height + 2, r=screw_diameter / 2);
      }
    }

  }

  // Right tab
  translate([housing_width - fit_tolerance,0,0]) {
    difference() {
      cube([fit_tolerance + right_tab_width, tab_depth, housing_height / 4]);
      translate([right_tab_width - 3, 3, -1])
        cylinder(h=housing_height + 2, r=screw_diameter / 2);

    }
  }

}


module cable_port() {
  translate([0,2.75,2.75])
    rotate([0,90,0])
    cylinder(h=cable_insert_length, r=2.75);
}

module usb_cutout() {
  cutout_height = 3.2 + (2 * fit_tolerance);
  cutout_width = 9 + (2 * fit_tolerance);
  cutout_depth = 14 + (2 * fit_tolerance);
  connector_depth = 10.6;
  connector_lip_offset = connector_depth - exposed_connector - fit_tolerance;

  translate([(housing_width - cutout_width) / 2, 0, (housing_height - cutout_height) / 2]) {
    difference() {
      cube([cutout_width, cutout_depth, cutout_height]);
      translate([-fit_tolerance, connector_lip_offset, -fit_tolerance])
        cube([cutout_width + (fit_tolerance * 2), cutout_depth - connector_lip_offset + fit_tolerance, 0.8]);
    }
  }
}

module cable_port_cutout() {
  usb_cutout_width = 9 + (2 * fit_tolerance);
  usb_cutout_offset = (housing_width - usb_cutout_width) / 2;
  cutout_length = usb_cutout_width + usb_cutout_offset;
  translate([-cutout_length + fit_tolerance, 2.75, 2.75])
    rotate([0,90,0])
    cylinder(h=cutout_length + cable_insert_length, r=2);
}

difference() {
  union() {
    if (mode == "top" || mode == "both")
      top();
    if (mode == "bottom" || mode == "both") {
      bottom();
      translate([housing_width - fit_tolerance,housing_depth - 5.5,0])
        cable_port();
    }
  }
  union () {
    translate([0, -(2 + fit_tolerance), 0])
      usb_cutout();
    translate([housing_width - fit_tolerance, housing_depth - 5.5, 0])
      cable_port_cutout();
  }
}

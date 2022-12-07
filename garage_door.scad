use <project_box.scad>
$fn=50;

mode = "all"; // ["case", "lid", "all"]

x = 50;
y = 70;
z = 30;

module cutouts() {
  // USB Port (Front)
  cutout_front([x,y,z])
    translate([10, 5, 0])
    square([15,10]);

  // Switch (Back)
  cutout_back([x,y,z])
    translate([10, 5, 0])
    square([15,10]);

  // Sensor Wires (Right)
  cutout_right([x,y,z])
    translate([10,5,0])
    square([15,10]);

  // Something (Left)
  cutout_left([x,y,z])
    translate([10,5,0])
    square([15,10]);

  // LEDs (Top)
  cutout_top([x,y,z])
    translate([10,5,0])
    square([15,10]);
}

project_box([x, y, z],
            below=10,
            mode=mode) {
  cutouts();
}

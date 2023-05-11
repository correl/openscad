/* WLED Controller
 *
 * A version of the project box designed to encase an ESP8266 Wemos D1-Mini with
 * a slot for wires connecting to its pins. Assumes a right-angle connector is
 * soldered to the board.
 */

use <project_box.scad>
$fn=50;

mode = "all"; // ["case", "lid", "all"]

x = 27;
y = 35;
z = 7;
below = 5;

project_box([x, y, z],
            below=below,
            mode=mode) {
  // Switch Sensor (Left)
  cutout_right([x,y,z])
    translate([5,1.5])
    square([10,5]);
  // USB Port (Front)
  cutout_front([x,y,z])
    translate([7, -5, 0])
    square([15,10]);

}

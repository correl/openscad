/* Garage Door Controller

   Holds a Wemos D1 Mini ESP8266 alongside a single relay board for controlling
   a garage door, a two-wire screw input for a reed switch, and two LEDs for
   power and status. All of this is mounted on a 5cmx7cm perforated circuit
   board.

   Project info: https://correl.phoenixinquis.net/2022/10/24/automating-our-garage-door-with-an-esp2866-and-home-assistant.html
 */

use <project_box.scad>
$fn=50;

mode = "all"; // ["case", "lid", "all"]

x = 50;
y = 70;
z = 21;
below = 8;

project_box([x, y, z],
            below=below,
            mode=mode) {
  // USB Port (Front)
  cutout_front([x,y,z])
    translate([9, -2, 0])
    square([15,10]);

  // Switch Control (Back)
  cutout_back([x,y,z])
    translate([2, 5, 0])
    square([16,8]);

  // Switch Sensor (Left)
  cutout_left([x,y,z])
    translate([5,0,0])
    square([11,7]);

  // Switch Control Screws (Top)
  cutout_top([x,y,z])
    translate([x - 18, y - 5,0])
    square([16, 8]);

  // Switch Sensor Screws (Top)
  cutout_top([x,y,z])
    translate([2, y - 12])
    square([7,11]);

  // LEDs (Top)
  cutout_top([x,y,z])
    translate([16, y - 14])
    union() {
      // 10x5 rounded rectangle
      translate([2.5, 2.5])
        circle(2.5);
      translate([2.5,0])
        square([5,5]);
      translate([7.5,2.5])
        circle(2.5);
    }
}

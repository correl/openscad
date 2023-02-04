$fn=50;

corner_radius = 10;
width = 150;
depth = 75;
height = 75;
wall_width = 5;

drawer_thickness = 30;
drawer_height = 30;

module container(dimensions, r) {
  hull() {
    translate([dimensions.x/2, dimensions.y/2, r])
      sphere(r);
    translate([dimensions.x/2, -dimensions.y/2, r])
      sphere(r);
    translate([-dimensions.x/2, dimensions.y/2, r])
      sphere(r);
    translate([-dimensions.x/2, -dimensions.y/2, r])
      sphere(r);
    translate([dimensions.x/2, dimensions.y/2, dimensions.z + r - 1])
      cylinder(h=1, r=r);
    translate([dimensions.x/2, -dimensions.y/2, dimensions.z + r- 1])
      cylinder(h=1, r=r);
    translate([-dimensions.x/2, dimensions.y/2, dimensions.z + r - 1])
      cylinder(h=1, r=r);
    translate([-dimensions.x/2, -dimensions.y/2, dimensions.z + r - 1])
      cylinder(h=1, r=r);
  }
}

module scrap_bin(dimensions, corner_radius, wall_width) {
  w = dimensions.x - corner_radius;
  d = dimensions.y - corner_radius;
  h = dimensions.z - corner_radius;

  difference() {
    container([w, d, h], r=corner_radius);
    translate([0,0,wall_width])
      container([w - wall_width, d - wall_width, h - wall_width + 1], r=corner_radius);
  }
  translate([-w/2, d/2 + corner_radius - 1, h + corner_radius - wall_width])
    cube([w, drawer_thickness + 1, wall_width]);
  translate([-w/2, d/2 + corner_radius + drawer_thickness - 1, h + corner_radius - wall_width - drawer_height])
    cube([w, wall_width + 1, drawer_height + wall_width]);
}

scrap_bin([width, depth, height], corner_radius, wall_width);

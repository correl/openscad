$fn = 50;

mode = "cat"; // ["cat", "dog"]
base_y = 1;
emboss_y = 1;


module cat() {
    translate([20,10,base_y]) {
    linear_extrude(emboss_y)
      text("Cat", font="Beleren", halign="center");
  }
  translate([20,2,base_y]) {
    linear_extrude(emboss_y)
      text("2/2", font="Beleren", size=5, halign="center");
  }
  translate([3,37,base_y])
    linear_extrude(emboss_y)
    scale(.08)
    import("mtg_token/Cat_silhouette.svg");
}

module dog() {
    translate([20,10,base_y]) {
    linear_extrude(emboss_y)
      text("Dog", font="Beleren", halign="center");
  }
  translate([20,2,base_y]) {
    linear_extrude(emboss_y)
      text("3/1", font="Beleren", size=5, halign="center");
  }
  translate([5,41,base_y])
    linear_extrude(emboss_y)
    scale(.07)
    import("mtg_token/Dog_silhouette.svg");
}

hull() {
cube([40, 30, base_y]);
translate([10,40,0])
  cylinder(r=10, h=base_y);
translate([30,40,0])
  cylinder(r=10, h=base_y);
}
color("white") {
  if (mode == "cat") {
    cat();
  } else {
    dog();
  }
}

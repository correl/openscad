use <project_box.scad>
$fn=50;

mode = "case"; // ["case", "lid", "all"]

project_box([50, 70, 0],
            below=1,
            mode=mode);

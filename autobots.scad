TARGET_INCHES = 18;
TARGET_MM = TARGET_INCHES * 25.4;
ORIGINAL_R = 200;
//GLOBAL_SCALE = 1.143;
GLOBAL_SCALE = (((TARGET_MM / 2) - ORIGINAL_R) / ORIGINAL_R) + 1;
PLATE_HEIGHT = 4;
POST_HEIGHT = 10;
POST_R = 3;
WELL_THICKNESS = 2;
TOLERANCE = 0.1;
MINI_HEX_R = 12.5;
MIN_HEX_GAP = 3;
SQRT2 = sqrt(2);
SQRT3 = sqrt(3);
eps = .01;

ALL_POSTS = [
    // Nose
    [0, 20],
    [0, -50],
    
    // Mouth
    [35, -40],
    [38, -110],
    
    // Cheeks
    [100, -5],
    [95, -90],
    [70, -100],
    [65, -50],
    
    // Chin
    [15, -128],
    [0, -110],
    
    // Brows
    [110, 90],
    [91, 15],
    [38, 40],
    [35, 10],
    
    // Forehead
    [75, 90],
    [0, 57],
    [0, 105]
];

cracks = [
    [[6, 9, 4], 180, ["L", "R", "L", "R", "L", "R", "L", "R"]],
    [[9, 11, 0], 300, ["R", "R", "L", "L", "R", "L", "R", "L", "R"]],
    [[12, 12, 1], 240, ["L", "L", "R", "R", "L", "R", "L", "R", "L"]],
    [[14, 9, 5], 0, ["R", "L", "R", "L", "R", "L", "R", "L"]],
    [[6, 7, 4], 180, ["R", "L", "R", "L", "R", "L", "R", "L", "R"]],
    [[14, 7, 5], 0, ["L", "R", "L", "R", "L", "R", "L", "R", "L"]],
    [[12, 5, 0], 60, ["R", "L", "R", "L", "L", "R", "L", "R", "L", "R", "L"]],
    [[8, 5, 3], 120, ["L", "R", "L", "R", "R", "L", "R", "L", "R", "L", "R"]],
];
    

function toCoords(allPoints, z) = [ 
    for (p2d = allPoints) 
        if (p2d.x == 0) [p2d.x * GLOBAL_SCALE, p2d.y * GLOBAL_SCALE, z] 
        else each [
            [p2d.x * GLOBAL_SCALE, p2d.y * GLOBAL_SCALE, z],
            [-p2d.x * GLOBAL_SCALE, p2d.y * GLOBAL_SCALE, z] 
        ]
];
        
function addZ(p2d, z) = [p2d.x, p2d.y, z];
        
function mirror2dy(points2d) = [
    for (p2d = points2d)
        if (p2d.y == 0) p2d
        else each [
            p2d,
            [p2d.x, -p2d.y]
        ]
];
        
function stackHexes(start, end, point) = [
    for (y = [point.y : SQRT3 * MINI_HEX_R : SQRT3 * (end - start) / 4]) [point.x, y]
];
        
function hexCenterSeries(start, end) = mirror2dy([
    for (x = [start + MINI_HEX_R : 3 * MINI_HEX_R : end]) each stackHexes(start, end, [x,0]) 
]);
    
function hexOffsetSeries(start, end) = mirror2dy([
    for (x = [start + 5 * MINI_HEX_R / 2 : 3 * MINI_HEX_R : end]) each stackHexes(start, end, [x, SQRT3/2 * MINI_HEX_R])
]);
    
function hexPoint(x, y, p) =
    let (
        gridx = -ORIGINAL_R + (x*MINI_HEX_R*3/2) + MINI_HEX_R, 
        gridy = ORIGINAL_R * SQRT3/2 - (y*MINI_HEX_R * SQRT3) - (x%2 == 1 ? SQRT3 * MINI_HEX_R / 2 : 0)
    )
    p == 0 ? [gridx - MINI_HEX_R, gridy] :
    p == 1 ? [gridx - MINI_HEX_R / 2, gridy + MINI_HEX_R * SQRT3 / 2] :
    p == 2 ? [gridx + MINI_HEX_R / 2, gridy + MINI_HEX_R * SQRT3 / 2] :
    p == 3 ? [gridx + MINI_HEX_R, gridy] : 
    p == 4 ? [gridx + MINI_HEX_R / 2, gridy - MINI_HEX_R * SQRT3 / 2] :
    p == 5 ? [gridx - MINI_HEX_R / 2, gridy - MINI_HEX_R * SQRT3 / 2] :
    p == 6 ? [gridx, gridy] : 
    [0,0];

function arc(r, angle, steps) = 
    [for (theta = [0: angle/steps: angle]) [r * cos(theta), -r * sin(theta)]];
    
module Posts(points=[]) {
    for (p = points) {
        color("DarkRed", 1)
        translate(p)
        linear_extrude(POST_HEIGHT)
        circle(r=POST_R - TOLERANCE);
    }
}

module Wells(points=[]) {
    for (p = points) {
        color("Gray", 1)
        translate(p)
        linear_extrude(POST_HEIGHT)
        difference() {
            circle(r=POST_R + WELL_THICKNESS);
            circle(r=POST_R + TOLERANCE);
        }
    }
}

module AutobotLogo() {
    LOGO_CENTERING = [-400, -150, 0];
    
    color("Red", 1)
    translate([0, 0, PLATE_HEIGHT + POST_HEIGHT])
    linear_extrude(PLATE_HEIGHT)
    scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
    translate(LOGO_CENTERING)
    import("autobots-manual.svg");
    
    Posts(toCoords(ALL_POSTS, PLATE_HEIGHT));
}

module AutobotBase() {
    color("LightGray", 1)
    scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
    cylinder(r=200, h=PLATE_HEIGHT, $fn=6);
    
    Wells(toCoords(ALL_POSTS, PLATE_HEIGHT));
}

module HexBase() {
    centeredList = hexCenterSeries(-ORIGINAL_R, ORIGINAL_R);
    offsetList = hexOffsetSeries(-ORIGINAL_R, ORIGINAL_R);
    //cols = [for (c = [-200 + MINI_HEX_R : 3 * MINI_HEX_R : 200]) [c, 0] ];
    for (hex = centeredList) {
        color("Yellow", .1)
        scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
        translate(addZ(hex, 0))
        cylinder(r=MINI_HEX_R - MIN_HEX_GAP / SQRT3, h=2, $fn=6);
    }
    for (hex = offsetList) {
        color("Yellow", .1)
        scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
        translate(addZ(hex, 0))
        cylinder(r=MINI_HEX_R - MIN_HEX_GAP / SQRT3, h=2, $fn=6);
    }

}

module CenterPlate() {
    translate([0, -10, 0])
    linear_extrude(PLATE_HEIGHT)
    square(size=[175, 175], center=true);
}

module Plate() {
    translate([0, 0, 6])
    linear_extrude(2)
    square(size=[175, 175], center=true);
}

module UnclippedPlates() {
    translate([-175/2+10, 165, 0])
    color("Red")
    Plate();
    translate([175/2+10, 165, 0])
    color("Orange")
    Plate();
    translate([-175/2+10, -185, 0])
    color("Yellow")
    Plate();
    translate([175/2+10, -185, 0])
    color("Green")
    Plate();

    translate([175, -10, 0])
    color("Blue")
    Plate();

    translate([-175+33, 175/2-30, 0])
    color("Purple")
    Plate();
    translate([-175+33, -175/2-30, 0])
    color("Pink")
    Plate();
}

module ClippedPlates() {
    intersection() {
        UnclippedPlates();
        scale([GLOBAL_SCALE, GLOBAL_SCALE, 6])
        cylinder(r=200, h=2, $fn=6);
    };
}

module HexGridSphere(x, y, p) {
    color("Yellow")
    scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
    translate(addZ(hexPoint(x, y, p), 0))
    sphere(MIN_HEX_GAP/SQRT3);
}

module TestHex(x, y) {
HexGridSphere(x, y, 0);
HexGridSphere(x, y, 1);
HexGridSphere(x, y, 2);
HexGridSphere(x, y, 3);
HexGridSphere(x, y, 4);
HexGridSphere(x, y, 5);
HexGridSphere(x, y, 6);
}


module Wedge(r, angle, steps) {
    polygon([[0, 0], each arc(r, angle, steps)]);
}

module HexWalk2(directions, tolerance, i=0) {
    gap = MIN_HEX_GAP + 2*tolerance;
    if (i == 0) {
        translate([gap / (SQRT3 * 2), 0, 0])
        circle(r=gap/2, $fn=50);
    }
       
    translate([gap / (SQRT3 * 2) + (MINI_HEX_R - gap / SQRT3)/2, 0, 0])
    square([MINI_HEX_R - gap / SQRT3 + 2*eps, gap], center=true);
    
    if (i < len(directions)) {
        translate([MINI_HEX_R - gap / (SQRT3 * 2), gap/2 * (directions[i] == "L" ? 1 : -1) , 0])
        rotate([0, 0, directions[i] == "L" ? -30 : 30])
        Wedge(gap, directions[i] == "L" ? 60 : -60, 12);
        //circle(r=gap, $fn=50);
                
        translate([MINI_HEX_R, 0, 0])
        rotate([0, 0, directions[i] == "L" ? 60 : -60])
        HexWalk2(directions, tolerance, i+1);
    } else {
        translate([MINI_HEX_R - gap / (SQRT3 * 2), 0, 0])
        circle(r=gap/2 + tolerance, $fn=50);
    }
        
}

module Crack(startPoint, startAngle, directions, tolerance=TOLERANCE) {
    scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
    translate(addZ(hexPoint(startPoint.x, startPoint.y, startPoint.z), 0))
    rotate([0, 0, startAngle])
    linear_extrude(PLATE_HEIGHT)
    union() {
        HexWalk2(directions, tolerance);
    }
}

module AllCracks(tolerance = TOLERANCE) {
    for (crack = cracks) {
        Crack(crack[0], crack[1], crack[2], tolerance);
    }
}

module AutobotCrackedBase() {
    difference() {
        AutobotBase();
        AllCracks();
        translate([0, -10, 0])
        cube(175, center=true);
    }
}

module CrackInserts() {
    intersection() {
        AutobotBase();
        AllCracks(-TOLERANCE);
    }
}

module AutobotCenterBase() {
    intersection() {
        difference() {
            AutobotBase();
            AllCracks();
        }
        translate([0, -10, 0])
        cube(175, center=true);
    }
}

AutobotLogo();
AutobotCrackedBase();
AutobotCenterBase();
CrackInserts();



/*
intersection() {
    AutobotBase();
    translate([0, -10, 0])
    cube(175, center=true);
}
*/




//AllCracks(-TOLERANCE);
//Cracks();
//CenterPlate();
//HexBase();
//ClippedPlates();


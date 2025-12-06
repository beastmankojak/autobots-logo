use <lib/floating-svg.scad>;
use <lib/utilities.scad>;

TARGET_INCHES = 18;
TARGET_MM = TARGET_INCHES * 25.4;
ORIGINAL_R = 200;
//GLOBAL_SCALE = 1.143;
GLOBAL_SCALE = (((TARGET_MM / 2) - ORIGINAL_R) / ORIGINAL_R) + 1;
PLATE_HEIGHT = 4;
POST_HEIGHT = 10;
POST_R = 3;
WELL_THICKNESS = 2;
TOLERANCE = 0.05;
MINI_HEX_R = 12.5;
MIN_HEX_GAP = 3;
SQRT2 = sqrt(2);
SQRT3 = sqrt(3);
eps = .01;
GROOVE = 1;

POST_POINTS = [
    // Crown
    [0, 5],
    [15, 25],
    [0, 75],
    [33, 115],

    // Cheeks
    [35, -120],
    [97, -35],
    [90, -94]
];

ALL_POSTS = addZ(mirror2dx(POST_POINTS), PLATE_HEIGHT);

module LogoCuts() {
    // translate([30.8, 4, 16])
    translate([40.8, 8, 16])
    rotate(a=[0, 0, 81])
    cube(size=[33, 2, 5], center=true);

    translate([-40.8, 8, 16])
    rotate(a=[0, 0, 99])
    cube(size=[33, 2, 5], center=true);

    translate([-50, -38, 16])
    rotate(a=[0, 0, 60])
    cube(size=[50, 2, 5], center=true);

    translate([50, -38, 16])
    rotate(a=[0, 0, 120])
    cube(size=[50, 2, 5], center=true);

}

module DecepticonLogo() {
    color("MediumPurple")
    difference() {
        FloatingSVG(svg="decepticons-manual.svg", offset=[-150, -150], 
            plateH=PLATE_HEIGHT, postH=POST_HEIGHT, scale=GLOBAL_SCALE);

        scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
        LogoCuts();
        
    }

    color("Purple")
    Posts(points=ALL_POSTS, postH=POST_HEIGHT, postR=POST_R, tolerance=TOLERANCE, scale=GLOBAL_SCALE);
}

module DecepticonBase() {
    color("LightGray", 1)
    HexBase(r=ORIGINAL_R, h=PLATE_HEIGHT, scale=GLOBAL_SCALE);
    
    //Wells(toCoords(ALL_POSTS, PLATE_HEIGHT));
}

// difference() {
    //DecepticonLogo();
    //DecepticonBase();
    CenterBaseVolume(175 + 2*TOLERANCE);
    // translate([-50, -60, 16])
    // rotate(a=[0, 0, 60])
    // cube(size=[50, 4, 5], center=true);
// }

    



//DecepticonBase();
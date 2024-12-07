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

module DecepticonLogo() {
    LOGO_CENTERING = [-150, -150, 0];
    
    color("Purple", 1)
    translate([0, 0, PLATE_HEIGHT + POST_HEIGHT])
    linear_extrude(PLATE_HEIGHT)
    scale([GLOBAL_SCALE, GLOBAL_SCALE, 1])
    translate(LOGO_CENTERING)
    import("decepticons-manual.svg");
    
    //Posts(toCoords(ALL_POSTS, PLATE_HEIGHT));
}

DecepticonLogo();
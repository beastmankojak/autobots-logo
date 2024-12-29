DEFAULT_SCALE = 1;
DEFAULT_PLATE_HEIGHT = 4;
DEFAULT_POST_H = 10;
DEFAULT_POST_R =  3;
DEFAULT_WELL_THICKNESS = 2;
DEFAULT_TOLERANCE = .1;

module Posts(points=[], postH=DEFAULT_POST_H, postR=DEFAULT_POST_R,
             tolerance=DEFAULT_TOLERANCE, scale=DEFAULT_SCALE) {
    for (p = points) {
        scale([scale, scale, 1])
        translate(p)
        linear_extrude(postH)
        circle(r=postR - tolerance);
    }
}

module Wells(points=[], postH=DEFAULT_POST_H, postR=DEFAULT_POST_R, thickness=DEFAULT_WELL_THICKNESS, 
             tolerance=DEFAULT_TOLERANCE, scale=DEFAULT_SCALE) {
    for (p = points) {
        scale([scale, scale, 1])
        translate(p)
        linear_extrude(postH)
        difference() {
            circle(r=postR + thickness);
            circle(r=postR + tolerance);
        }
    }
}

module HexBase(r, h=DEFAULT_PLATE_HEIGHT, scale=DEFAULT_SCALE) {
    scale([scale, scale, 1])
    cylinder(r=r, h=h, $fn=6);
}

module FloatingSVG(svg, offset=[0, 0], plateH=DEFAULT_PLATE_HEIGHT, postH=DEFAULT_POST_H, scale=DEFAULT_SCALE) {
    scale([scale, scale, 1])
    translate([offset.x, offset.y, plateH + postH])
    linear_extrude(plateH)
    import(str("../", svg));
  }
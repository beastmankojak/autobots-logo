function addZ(p2d, z) = [
  for (p = p2d)
    [p.x, p.y, z]
];
        
function mirror2dy(points2d) = [
    for (p2d = points2d)
        if (p2d.y == 0) p2d
        else each [
            p2d,
            [p2d.x, -p2d.y]
        ]
];

function mirror2dx(points2d) = [
  for (p2d = points2d)
    if (p2d.x == 0) p2d
    else each [
      p2d,
      [-p2d.x, p2d.y]
    ]
];
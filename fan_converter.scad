$fn=64;
m=4;

module peg(h,r) {
    hull() {
        scale([1,1,0])
            cylinder(h=1, r=r);
        translate([0,0,-h+r])
            difference() {
                sphere(r=r);
                translate([-r,-r,0])
                    cube([r*2,r*2,r]);
            }
    }
}

module fan_mount(size, height) {
    corner_radius = size/10;
    
    translate([corner_radius,corner_radius,0])
        resize([size,size,height])
            minkowski() {
                cube([
                    size-2*corner_radius,
                    size-2*corner_radius,
                    2,
                ]);
                cylinder(r=corner_radius);
            }
}

module nut_socket(inner_diameter, height, hole=true) {
    r = inner_diameter/2;
    
    if (hole) {
        difference() {
            cylinder(r=r+0.5, h=height, $fn=6);
            cylinder(r=r, h=height, $fn=6);
        }
    } else {
        cylinder(r=r+0.5, h=height, $fn=6);
    }
}

module 40mm_fan(height) {
    difference() {
        union() {
            fan_mount(40, height);
            
            // Pegs
            translate([4,4,0])
                peg(3, m/2);
            translate([40-4,4,0])
                peg(3, m/2);
            translate([40-4,40-4,0])
                peg(3, m/2);
            translate([4,40-4,0])
                peg(3, m/2);
        }
        
        // Center hole
        translate([20,20,0])
            cylinder(h=height, d=38);
    }
}

module nut_sockets(nut_diameter, height, hole=true) {
    // Rotation of the nut socket
    // Each edge: 360 / 6 = 60 degrees
    // Quater turn: 60 / 4 = 15 degrees
    rotation = 15; // degrees

    translate([5,5,-3])
        rotate(rotation)
        nut_socket(nut_diameter, height, hole);
    translate([50-5,5,-3])
        rotate(rotation+30)
        nut_socket(nut_diameter, height, hole);
    translate([50-5,50-5,-3])
        rotate(rotation)
        nut_socket(nut_diameter, height, hole);
    translate([5,50-5,-3])
        rotate(rotation+30)
        nut_socket(nut_diameter, height, hole);
}

module 50mm_fan(height) {
    union() {
        difference() {
            fan_mount(50, height);

            // Screw Holes
            translate([5,5,0])
                cylinder(h=height*2, d=4.3);
            translate([50-5,5,0])
                cylinder(h=height*2, d=4.3);
            translate([50-5,50-5,0])
                cylinder(h=height*2, d=4.3);
            translate([5,50-5,0])
                cylinder(h=height*2, d=4.3);

            // Center hole
            translate([25,25,0])
                cylinder(h=height, d=48);
        }
        
//        nut_sockets(8.5, 3, true);
    }
}

module fan_converter() {
    rotation = 0; // degrees
    height = 6; // mm
    bracket_thickness = 1; // mm

    difference() {
        union() {
            difference() {
                union() {
                    // 40mm bracket
                    translate([20,20,0])
                        rotate(rotation)
                            translate([-20,-20,0])
                                40mm_fan(bracket_thickness);

                    // External tube
                    hull() {
                        translate([20,20,height])
                            scale([1,1,0])
                               cylinder(d=50, h=1);
                        translate([20,20,bracket_thickness])
                            rotate(rotation)
                                translate([-20,-20,0])
                                    scale([1,1,0])
                                        fan_mount(40, 1);
                    }
                }
                
                // External tube nut socket cut-out
                translate([-5,-5,0])
                    nut_sockets(8, height*2, false);
            }
            
            // 50mm bracket
            translate([-5,-5,height])
                50mm_fan(bracket_thickness);
        }

        // Internal tube cut-out
        translate([20,20,bracket_thickness])
            cylinder(h=height-bracket_thickness, d1=38, d2=48);
    }
}

fan_converter();
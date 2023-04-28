$fn=64;
m=3;

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

module nut_socket(inner_diameter, height) {
    r = inner_diameter/2;
    
    difference() {
        cylinder(r=r+1, h=height, $fn=6);
        cylinder(r=r, h=height, $fn=6);
    }
}

module 40mm_fan() {
    h = 1;

    difference() {
        union() {
            fan_mount(40, h);
            
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
            cylinder(h=h, d=38);
    }
}

module 50mm_fan() {
    h = 1;
    
    union() {
        difference() {
            fan_mount(50, h);
            
            // Screw Holes
            translate([5,5,0])
                cylinder(h=h*2, d=4.3);
            translate([50-5,5,0])
                cylinder(h=h*2, d=4.3);
            translate([50-5,50-5,0])
                cylinder(h=h*2, d=4.3);
            translate([5,50-5,0])
                cylinder(h=h*2, d=4.3);

            // Center hole
            translate([25,25,0])
                cylinder(h=h, d=48);
        }
        
        // Nut sockets
        translate([5,5,-3])
            rotate(8)
            nut_socket(7, 3);
        translate([50-5,5,-3])
            rotate(38)
            nut_socket(7, 3);
        translate([50-5,50-5,-3])
            rotate(8)
            nut_socket(7, 3);
        translate([5,50-5,-3])
            rotate(38)
            nut_socket(7, 3);
    }
}

module fan_converter() {
    difference() {
        union() {
            translate([20,20,0])
                rotate(22.5)
                    translate([-20,-20,0])
                        40mm_fan();

            hull() {
                translate([20,20,5])
                    scale([1,1,0])
                        cylinder(d=50, h=1);
                translate([20,20,1])
                    rotate(22.5)
                        translate([-20,-20,0])
                            scale([1,1,0])
                                fan_mount(40, 1);
            }
            
            translate([-5,-5,5])
                50mm_fan();
        }

        translate([20,20,1])
            cylinder(h=4, d1=38, d2=48);
    }
}

fan_converter();
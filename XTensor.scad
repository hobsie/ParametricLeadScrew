$fn=32;

translate([0,0,45]) rotate(a=90, v=[0,1,0]) {
    difference() {
        mainBody(45,8,28);
        mainSubtractions(45,8,28);
    }
}

module cubeWithXHorizontalFillets(length, width, height, radius, center) {
    diameter = radius * 2;
    translate([0, radius/2, radius/2]) {
        minkowski() {
            cube([length/2, width-radius, height-radius]);
            rotate(a=90,v=[0,1,0]) cylinder(r=radius/2,h=length/2);
        } 
    }
}

module mainBody(length, width, height) 
{
	offsetValue = length - 5;
	difference()
	{
		cubeWithXHorizontalFillets(length - 10, width, height, 6);
		translate([offsetValue - 5, 9, 14]) scale([1.4,1,1]) rotate(a=90,v=[1,0,0]) cylinder(h = 10, r = 10.5);
	}
	difference()
	{
		translate([length - 10, -5, -1]) cubeWithXHorizontalFillets(10,18,30,8);
		translate([offsetValue - 5.1, -1, 3.5]) cubeWithXHorizontalFillets(10.2,10,21,2);
	}
}

module mainSubtractions(length, width, height) {
    offsetValue = length - 5;
	translate([10, 1.4, 8]) cube([1.1, 5.2, 12]);
    translate([11, -0.1, 8]) cube([20, 8.2, 12]);
    translate([-0.1,4,14]) rotate(a=90,v=[0,1,0]) cylinder(h=10,r=2.1);
    translate([7,4,14]) rotate(a=90,v=[0,1,0]) cylinder($fn=6, h=3.1,r=3);
    
    // Pully Hole
    translate([offsetValue,13.1,14]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.6);
    translate([offsetValue,13.1,14]) rotate(a=90, v=[1,0,0]) cylinder(h=1.6,r=3);
    translate([offsetValue,-4,14]) rotate(a=90, v=[1,0,0]) cylinder($fn=6, h=1.5,r=3.1);
}
include <Settings.scad>
use <Modules.scad>

pulleyWidth = 8.5;
pulleySpacer =0.5;
pulleyRadius = 8;
pulleyCavityExtra = 1;

guideGap = 0.5;
guideLength = 20;

//beltTensionerScrewHoleRadius = 1.75; // Radius of the screw hole used to either attach a tensioner or pulley
//beltTensionerNutRadius = 5.5 / 2 / cos(180 / 6) + 0.35;

pulleyCavityWidth = pulleyWidth + (pulleySpacer * 2) + pulleyCavityExtra;
pulleyCavityHeight = pulleyRadius * 2 + pulleyCavityExtra;
wallThickness = (bodyLength - pulleyCavityWidth) / 2;

checkBodyHeight(linearBearingHeight, gapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);
bodyHeight = calculateBodyHeight(linearBearingHeight, gapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);

centerZ = bodyHeight / 2;
centerX = bodyLength / 2;
centerY = bodyLength / 2;

guideWidth = beltTensionVoidWidth - guideGap * 2;
guideHeight = (beltTensionVoidHeight - pulleyCavityHeight) / 2 - guideGap;
guideVerticalOffset = (bodyHeight  - beltTensionVoidHeight) / 2 + guideGap;

TightenerHoleVerticalffset = (bodyHeight - distanceBetweenSmoothRods) / 2;

translate([bodyHeight /2, - (bodyLength / 2), 0]) rotate([0, -90, 0])
{
    difference()
    {
        cubeWithVerticalFillets(bodyLength, bodyLength, bodyHeight, 2);

        translate([-fudge, wallThickness, (bodyHeight - pulleyCavityHeight) / 2])
            cube([ bodyLength + (fudge * 2), pulleyCavityWidth, pulleyCavityHeight]);
        translate([bodyLength / 2, -fudge, bodyHeight / 2]) rotate([0,90,90])
            ScrewHole(bodyLength, beltTensionerScrewHoleRadius, 3, 1.5, beltTensionerNutRadius, 1.5);
        TightenerHole(TightenerHoleVerticalffset);
        TightenerHole(bodyHeight - TightenerHoleVerticalffset);
    }
    
    //pulley spacer rings
    translate([centerX, wallThickness, centerZ]) rotate([0,90,90])
        ring(beltTensionerScrewHoleRadius + 1, beltTensionerScrewHoleRadius, pulleySpacer, fudge);
    translate([centerX, wallThickness + pulleyCavityWidth - pulleySpacer, centerZ]) rotate([0,90,90])
        ring(beltTensionerScrewHoleRadius + 1, beltTensionerScrewHoleRadius, pulleySpacer);

    //guides
    translate([bodyLength, (bodyLength - guideWidth) / 2, guideVerticalOffset])
        //Guide(guideLength, guideWidth, guideHeight, 8 - guideGap / 2, fudge);
        //ChopedGuide(guideLength, guideWidth, guideHeight, 2, fudge);
        RoundedGuide(guideLength, guideWidth, guideHeight, 8 - guideGap, fudge);
    translate([bodyLength, (bodyLength - guideWidth) / 2 + guideWidth, bodyHeight - guideVerticalOffset])
        rotate([180, 0, 0])
            RoundedGuide(guideLength, guideWidth, guideHeight, 8 - guideGap, fudge);

    //color([0.8, 0.8, 0.8]) translate([centerX, centerY + pulleyWidth / 2, centerZ]) rotate([90,0,0]) cylinder(h = pulleyWidth, r = pulleyRadius);

}


module RoundedGuide(length, width, height, radius, _fudge)
{
    difference() {
        cubeWithXHorizontalFillets(length, width, height * 2, radius);
        translate([-_fudge, -_fudge, height]) cube([length + 2 * _fudge, width + 2 * _fudge, height + _fudge]);
    }
}

module ChopedGuide(length, width, height, chop, _fudge) // x, y, z
{
    difference()
    {
        cube([length, width, height]);
        translate([0, width - chop, -_fudge])
            rotate([-45, 0, 0])
                cube([length + 2 * _fudge, chop * 2, chop * 2]);
        translate([0, chop, -_fudge])
            rotate([135, 0, 0])
                cube([length + 2 * _fudge, chop * 2, chop * 2]);
    }
}

module TightenerHole(z)
{
    translate([-fudge, bodyLength / 2, z]) rotate([0,90.0])
        cylinder(h = bodyLength + fudge * 2, r = beltTensionerScrewHoleRadius);
    translate([bodyLength - 3, bodyLength / 2, z])  rotate([0, 90, 0])
        cylinder(h = 3 + fudge, r = beltTensionerNutRadius, $fn = 6);
}


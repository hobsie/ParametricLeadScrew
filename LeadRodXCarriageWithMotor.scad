include <Settings.scad>

hasZStopScrew = true; // Setting this to true will add a section to screw in screw you can use to adjust z-stop min
hasXStopMount = false; // Setting this to true will add a mount for a X-min switch
hasCableChainMount = true; // Setting this to true will add 2 holes above the motor section to attach a cable chain mount
hasBearingDivider = true; // Adds a bearing divider in the bearing slot if true

// Calculated values
checkBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);
bodyHeight = calculateBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);

use <Modules.scad>

difference() 
{
    // Add
    mainBody(bodyHeight, leadRodCouplingHeight, linearBearingOuterRadius, leadRodCouplingOuterRadius, distanceBetweenLinearBearingAndLeadRod, distanceBetweenSmoothRodAndLinearBearing, leadRodYaxisOffset);
    
    // Sutract
    smoothRodAndBeltCavity(bodyHeight, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, BeltTensionVoidVerticalOffset);
    LinearBearingSubs(bodyHeight, linearBearingInnerRadius, linearBearingOuterRadius, distanceBetweenSmoothRodAndLinearBearing);
    LeadCouplingSubs(leadRodCouplingHeight, distanceBetweenSmoothRodAndLinearBearing, linearBearingOuterRadius, leadRodCouplingInnerRadius, distanceBetweenLinearBearingAndLeadRod, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType);
    CableChainMount(hasCableChainMount);
}

difference()
{
    MotorScrewChannels(bodyHeight);
    MotorScrewChannelSubtracts(bodyHeight);
}

LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, distanceBetweenSmoothRodAndLinearBearing);

ZStopScrewMount(hasZStopScrew, bodyHeight, linearBearingOuterRadius);
XStopSwitchMount(hasXStopMount);

// Modules and functions
module CableChainMount(hasCableChainMount)
{
    if(hasCableChainMount == true)
    {
        translate([75, 9, -fudge]) cylinder(h = 10, r = 1.4);
        translate([55, 9, -fudge]) cylinder(h = 10, r = 1.4);
    }
}

module XStopSwitchMount(hasXStopMount)
{
    if(hasXStopMount == true)
    {
        difference()
        {
            translate([-12, 0, 0]) cubeWithVerticalFilletsRadialWidth(17, 4, 25);
			translate([4, 0, 0]) cube([4, 4, 25]);
            translate([-7, 4 + fudge, 12.5 - 5]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 4 + fudge * 2, r = 1.4);
            translate([-7, 4 + fudge, 12.5 + 5]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 4 + fudge * 2, r = 1.4);
        }
    }
}
module ZStopScrewMount(hasZStopScrew, bodyHeight, linearBearingOuterRadius)
{
    if(hasZStopScrew == true)
    {
        difference()
        {
            translate([(linearBearingOuterRadius * 2) + 20 - 3, -6, bodyHeight - 12]) cubeWithVerticalFillets(9, 10, 12, 3);
            translate([(linearBearingOuterRadius * 2) + 20, -6 - fudge, bodyHeight - 25]) rotate(a = -30, v = [0, 1, 0]) cube([18, 10, 12]);
            translate([(linearBearingOuterRadius * 2) + 23, -3, bodyHeight - 11]) cylinder(h = 12, r = 1.4);
        }
    }
}

module MotorScrewChannels(bodyHeight)
{
    translate([64 - 15.5, 16, (bodyHeight / 2) - (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 14, r = 3);
    translate([64 - 15.5, 16, (bodyHeight / 2) + (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 14, r = 3);
}

module MotorScrewChannelSubtracts(bodyHeight)
{
    translate([64 - 15.5, 18, (bodyHeight / 2) - (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 18,r = 1.65);
    translate([64 - 15.5, 18, (bodyHeight / 2) + (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 18,r = 1.65);
}

module LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, linearYOffset) 
{
    linearBearingYPos = 9 - linearYOffset;
    linearBearingStopperYPos = linearBearingYPos + linearBearingInnerRadius;
    translate([linearBearingOuterRadius + 20, linearBearingYPos, 0]) rotate(a = 15, v = [0, 0, 1]) translate([0, 1.5 - linearBearingOuterRadius, 0]) cylinder(h = bodyHeight, r = 1.5);
    translate([linearBearingOuterRadius + 20, linearBearingYPos, 0]) rotate(a = -15, v = [0, 0, 1]) translate([0, 1.5 -linearBearingOuterRadius, 0]) cylinder(h = bodyHeight, r = 1.5);
	if(hasBearingDivider == true)
	{
		translate([linearBearingOuterRadius + 20, linearBearingStopperYPos, bodyHeight / 2]) cube([linearBearingOuterRadius * 2, 3, 9], center = true);
	}
}

module mainBody(height, leadHeight, linearRadius, leadRadius, linearLeadDist, linearYOffset, leadRodYaxisOffset) 
{
    // Main body
    cubeWithVerticalFillets(55, 18, height, 3);
    translate([48, 0, 0]) cubeWithVerticalFillets(37, 18, 22, 3);
    
    // Linear bearing housing
    linearBearingYPos = 9 - linearYOffset;
    translate([linearRadius + 20, linearBearingYPos, 0]) cylinder(h = height, r = linearRadius);
    translate([20, linearBearingYPos, 0]) cube([linearRadius * 2, abs(linearBearingYPos), height]);
    translate([18, -2, 0]) cube([2, 2, height]);
    translate([20 + (linearRadius * 2), -2, 0]) cube([2, 2, height]);
    
    // Lead rod bearing housing
    translate([linearRadius + 20 - linearLeadDist, linearBearingYPos + leadRodYaxisOffset, 0]) cylinder(h = leadHeight, r = leadRadius);
}

module LinearBearingSubs(height, linearInnerRadius, linearOuterRadius, yOffset)
{
    linearBearingYPos = 9 - yOffset;
    translate([linearOuterRadius + 20, linearBearingYPos, -fudge]) cylinder(h = height + fudge * 2, r = linearInnerRadius);
    translate([22 + (linearOuterRadius*2), -2, -fudge]) cylinder(h = height, r = 2);
    translate([18 , -2, 10]) cylinder(h = height - 10 + fudge, r = 2);
    translate([linearOuterRadius + 20, linearBearingYPos, height / 2 - fudge]) rotate(a = -15, v = [0, 0, 1]) translate([1.5, -linearOuterRadius + 1.5, 0]) cube([3, 4, height + fudge * 3], center = true);
    translate([linearOuterRadius + 20, linearBearingYPos, height / 2 - fudge]) rotate(a = 15, v = [0, 0, 1]) translate([-1.5, -linearOuterRadius + 1.5, 0]) cube([3, 4, height + fudge * 3], center = true);
}

module LeadCouplingSubs(height, yOffset, linearBearingOuterRadius, leadRodCouplingInnerRadius, linearLeadDist, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType)
{
	leadCouplingXPos = linearBearingOuterRadius + 20 - linearLeadDist;
    leadCouplingYPos = 9 - yOffset + leadRodYaxisOffset;
    translate([leadCouplingXPos, leadCouplingYPos, -fudge]) cylinder(h = height + fudge * 2, r = leadRodCouplingInnerRadius);
    
    if (leadRodBearingType == 0)
    {
        // Brass type bearing with 4 screw holes
        //Screw Holes
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 135, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 225, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 315, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        
        //Screw voids
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a = 45, v = [0, 0, 1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = 7, r = 3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height + 7]) rotate(a = 45, v = [0, 0, 1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) sphere(r = 3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a = 315, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = 7, r = 3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height + 7]) rotate(a = 315, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) sphere(r = 3.1);
    } 
    else if (leadRodBearingType == 1)
    {
        // Plastic type bearing with 3 screw holes
        //Screw Holes
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, -fudge]) rotate(a = -45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, -fudge]) rotate(a = -165, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, -fudge]) rotate(a = -285, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        
        //Screw void
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, height]) rotate(a = -45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = 7, r = 3.1);
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, height+7]) rotate(a = -45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) sphere(r = 3.1);
    }
}

module smoothRodAndBeltCavity(bodyHeight, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, BeltTensionVoidVerticalOffset) 
{   
    // Smooth rod cavity
    translate([-fudge, 9, (bodyHeight / 2) - (distanceBetweenSmoothRods / 2)]) rotate(a = 90, v = [0, 1, 0]) cylinder(h = smoothRodInsertLength + fudge, r = smoothRodRadius);
    translate([-fudge, 9, (bodyHeight / 2) + (distanceBetweenSmoothRods / 2)]) rotate(a = 90, v = [0, 1, 0]) cylinder(h = smoothRodInsertLength + fudge, r = smoothRodRadius);
    
    // Belt Cavity
    translate([-fudge, 4, ((bodyHeight / 2) - (beltTensionVoidHeight / 2))]) cubeWithXHorizontalFillets(beltTensionVoidLength + fudge, beltTensionVoidWidth, beltTensionVoidHeight, 8);
    
    translate([64, 18 + fudge, bodyHeight / 2]) rotate(a = 90, v = [1, 0, 0]) hexagonWithFillets(18 + fudge * 2, 35/2, 4);
    translate([64 - 15.5, 18 + fudge, (bodyHeight / 2) - (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 18 + fudge * 2, r = 1.65);
    translate([64 - 15.5, 18 + fudge, (bodyHeight / 2) + (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 18 + fudge * 2, r = 1.65);
    translate([64 + 15.5, 18 + fudge, (bodyHeight / 2) - (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 18 + fudge * 2, r = 1.65);
    
    // Motor screw recess
    translate([64 - 15.5, 2 + fudge, (bodyHeight / 2) - (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 2 + fudge * 2, r = 3);
    translate([64 - 15.5, 2 + fudge, (bodyHeight / 2) + (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 2 + fudge * 2, r = 3);
    translate([64 + 15.5, 2 + fudge, (bodyHeight / 2) - (31 / 2)]) rotate(a = 90, v = [1, 0, 0]) cylinder(h = 2 + fudge * 2, r = 3);
}


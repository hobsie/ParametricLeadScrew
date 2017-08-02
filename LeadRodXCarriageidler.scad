include <Settings.scad>

beltTensionerType = 2; // 0 = No separate tensioner, 1 = Separate tensioner, any other: External belt tensioner

bodyWidth = 50;
// Calculated values
checkBodyHeight(linearBearingHeight, gapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);
bodyHeight = calculateBodyHeight(linearBearingHeight, gapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);

include <Modules.scad>

difference() 
{
    // Add
    mainBody(bodyWidth, bodyHeight, leadRodCouplingHeight, linearBearingOuterRadius, leadRodCouplingOuterRadius, distanceBetweenLinearBearingAndLeadRod, distanceBetweenSmoothRodAndLinearBearing, leadRodYaxisOffset);
    
    // Sutract
    smoothRodAndBeltCavity(bodyWidth, bodyHeight, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, beltTensionVoidVerticalOffset);
    LinearBearingSubs(bodyHeight, linearBearingInnerRadius, linearBearingOuterRadius, distanceBetweenSmoothRodAndLinearBearing);
    LeadCouplingSubs(leadRodCouplingHeight, distanceBetweenSmoothRodAndLinearBearing, linearBearingOuterRadius, leadRodCouplingInnerRadius, distanceBetweenLinearBearingAndLeadRod, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType);
}

LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, distanceBetweenSmoothRodAndLinearBearing);

module LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, linearYOffset) 
{
    linearBearingYPos = 9 - linearYOffset;
    linearBearingStopperYPos = linearBearingYPos + linearBearingInnerRadius;
    translate([linearBearingOuterRadius + 5, linearBearingYPos, 0]) rotate(a = 15, v = [0, 0, 1]) translate([0, 1.5 - linearBearingOuterRadius, 0]) cylinder(h = bodyHeight, r = 1.5);
    translate([linearBearingOuterRadius + 5, linearBearingYPos, 0]) rotate(a = -15, v = [0, 0, 1]) translate([0, 1.5 - linearBearingOuterRadius, 0]) cylinder(h = bodyHeight, r = 1.5);
	
	if(hasBearingDivider == true)
	{
		translate([linearBearingOuterRadius + 5, linearBearingStopperYPos, bodyHeight / 2]) cube([linearBearingOuterRadius * 2, 3, 9], center = true);
	}
}

module mainBody(width, height, leadHeight, linearRadius, leadRadius, linearLeadDist, linearYOffset, leadRodYaxisOffset)
{
    cubeWithVerticalFillets(width, bodyLength, height, 3);
    
    // Linear bearing housing
    linearBearingYPos = 9 - linearYOffset;
    translate([linearRadius + 5,linearBearingYPos, 0]) cylinder(h = height, r = linearRadius);
    translate([5, linearBearingYPos, 0]) cube([linearRadius * 2, abs(linearBearingYPos), height]);
    
    // Lead rod bearing housing
    translate([linearRadius + 5 + linearLeadDist, linearBearingYPos + leadRodYaxisOffset, 0]) cylinder(h = leadHeight, r = leadRadius);
    translate([3, -2, 0]) cube([2, 2, height]);
    translate([5 + (linearRadius * 2), -2, 0]) cube([2, 2, height]);
}

module LinearBearingSubs(height, linearInnerRadius, linearOuterRadius, yOffset)
{
    linearBearingYPos = 9 - yOffset;

    //  main hole
    translate([linearOuterRadius + 5, linearBearingYPos, -fudge]) cylinder(h = height + fudge * 2, r = linearInnerRadius);
    
    //join smoothings R,L
    translate([7 + (linearOuterRadius * 2), -2, 10]) cylinder(h = height - 10 + fudge, r = 2);
    translate([3, -2, -fudge]) cylinder(h = height + fudge * 2, r = 2);
    
    //LM8UU holder gap
    translate([linearOuterRadius + 5, linearBearingYPos, height / 2 - fudge]) rotate(a = -15, v = [0, 0, 1]) translate([1.5, 1.5 - linearOuterRadius, 0]) cube([3, 4, height + fudge * 3], center = true);
    translate([linearOuterRadius + 5, linearBearingYPos, height / 2 - fudge]) rotate(a = 15, v = [0, 0, 1]) translate([-1.5, 1.5 -linearOuterRadius, 0]) cube([3, 4, height + fudge * 3], center = true);
}

module LeadCouplingSubs(height, yOffset, linearBearingOuterRadius, leadRodCouplingInnerRadius, linearLeadDist, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType)
{
	leadCouplingXPos = linearBearingOuterRadius + 5 + linearLeadDist;
    leadCouplingYPos = 9 - yOffset + leadRodYaxisOffset;
    translate([leadCouplingXPos, leadCouplingYPos, -fudge]) cylinder(h = height + fudge * 2, r = leadRodCouplingInnerRadius);
    
    if (leadRodBearingType == 0)
    {
        // Brass type bearing with 4 screw holes
        // Screw Holes
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 45, v = [0,0,1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 135, v = [0,0,1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 225, v = [0,0,1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 315, v = [0,0,1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        
        // Screw voids
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a = 45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = 7, r = leadRodScrewCavityRadius);
        translate([leadCouplingXPos, leadCouplingYPos, height + 7]) rotate(a = 45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance]) sphere(r = leadRodScrewCavityRadius);
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a = 315, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = 7, r = leadRodScrewCavityRadius);
        translate([leadCouplingXPos, leadCouplingYPos, height + 7]) rotate(a = 315, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) sphere(r = leadRodScrewCavityRadius);
    } 
    else if (leadRodBearingType == 1)
    {
        // Plastic type bearing with 3 screw holes
        // Screw Holes
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 165, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, -fudge]) rotate(a = 285, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = height + fudge * 2, r = leadRodScrewHoleRadius);
        
        //Screw void
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a = 45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h = 7, r = leadRodScrewCavityRadius);
        translate([leadCouplingXPos, leadCouplingYPos, height + 7]) rotate(a = 45, v = [0, 0, 1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance]) sphere(r = leadRodScrewCavityRadius);
    }
        
}

module smoothRodAndBeltCavity(width, height, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, beltTensionVoidVerticalOffset) 
{   
    leadCouplingXPos = linearBearingOuterRadius + 5 + distanceBetweenLinearBearingAndLeadRod;
    // Smooth rod cavity
    smoothRodCavityOffset = max(0, width - smoothRodInsertLength) - fudge;
    translate([smoothRodCavityOffset, 9, (height - distanceBetweenSmoothRods) / 2]) rotate(a = 90, v = [0, 1, 0]) cylinder(h = smoothRodInsertLength + fudge * 2, r = smoothRodRadius);
    translate([smoothRodCavityOffset, 9, (height + distanceBetweenSmoothRods) / 2]) rotate(a = 90, v = [0, 1, 0]) cylinder(h = smoothRodInsertLength + fudge * 2, r = smoothRodRadius);
    
	if (beltTensionerType == 0)
	{
		// Belt Cavity
		translate([-fudge, 4, ((height / 2) - (beltTensionVoidHeight / 2))])
            cubeWithXHorizontalFillets(bodyWidth + fudge * 2, beltTensionVoidWidth, beltTensionVoidHeight, 8);
		translate([leadCouplingXPos, 0, 30]) rotate(a = -90, v = [1, 0, 0])
            ScrewHole(bodyLength, beltTensionerScrewHoleRadius, beltTensionerScrewHeadRadius, 1.5, beltTensionerNutRadius, 1.5);
	}
	else if (beltTensionerType == 1)
	{
		// Belt Cavity
		translate([5 + fudge, 4, ((height / 2) - (beltTensionVoidHeight / 2))]) cubeWithXHorizontalFillets(smoothRodInsertLength, beltTensionVoidWidth, beltTensionVoidHeight, 8);
		translate([-fudge, 9, 30]) rotate(a = 90, v = [0, 1, 0]) cylinder(h = 1.5 + fudge, r = beltTensionerScrewHoleRadius * 2);
		translate([0, 9, 30]) rotate(a = 90, v = [0, 1, 0]) cylinder(h = 5 + fudge * 2, r = beltTensionerScrewHoleRadius);
	}
    else
    {
		// Belt Cavity
		translate([-fudge, 4, ((height / 2) - (beltTensionVoidHeight / 2))])
            cubeWithXHorizontalFillets(bodyWidth + fudge * 2, beltTensionVoidWidth, beltTensionVoidHeight, 8);
    }
}



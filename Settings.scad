$fn=32; // Global fragment smoothing value.

// Notes: 
// I have tried to expose some of the more common parameters that you might need to tweak to fit the parts to your setup
// but there's still quite a lot of hardcoded values in there.
// Be aware that I tend to go quite narrow with screw holes as I like to tap them and get a good thread
fudge = 0.01;

hasBearingDivider = true; // Adds a bearing divider in the bearing slot if true

// You can adjust the following variables if your vitamin parts and alignment don't match the defaults
linearBearingInnerRadius = 7.6; // This should match the radius of the linear bearings
linearBearingOuterRadius = 10.5; // Bearing housing wall thickness is this value minus linearBearingInnerRadius
linearBearingHeight = 25.5; // This is the height of the enclosure for the linear bearing, not neccisarily the length of the bearing itself
GapBetweenLinearBearings = 9; // A stopper will be created between the linear bearings with this height to create a gap

leadRodCouplingInnerRadius = 5.4; // Lead rod coupling inner radius. If you want to insert the shaft of your lead rod bearing, you should set this value to match
leadRodCouplingOuterRadius = 11; // Lead rod coupling inner radius. Should match the total width of the lead rod bearing
leadRodCouplingHeight = 10; // 10mm seems to be a good value for this

smoothRodRadius = 4.12; // Radius of your X axis smooth rods. Go ever so slightly over to help with fit
smoothRodInsertLength = 50; // Distance into the printed part that the X axis smooth rod can go - may need altering depending on the length of your X smooth rods
distanceBetweenSmoothRods = 45; // The vertical distance between the center points of the smooth rods

beltTensionVoidHeight = 31; // Height of the void through the center of the part for the belt tensor
beltTensionVoidWidth = 10; // This value should be wide enough to house the belt or belt tensor
beltTensionVoidLength = 58; // Depth of the cavity
BeltTensionVoidVerticalOffset = 0; // The tension void will be position equally between the smooth rod holes unless offset

distanceBetweenSmoothRodAndLinearBearing = 15;
distanceBetweenLinearBearingAndLeadRod = 18; // X axis distance from the center of the linear bearing to the center of the lead rod
leadRodYaxisOffset = 0; // A positive value here will move the lead rod center away from the main body in the X axis, a negative value will be closer
leadRodBearingType = 0; // 0 = 4 screw holes, 1 = 3 screw holes
leadRodScrewHoleRadius = 1.75; // Screw hole size for the lead rod bearing
leadRodScrewHoleDistance = 2.5; // Linear distance direct from screw hole center to the leadRodCouplingInnerRadius



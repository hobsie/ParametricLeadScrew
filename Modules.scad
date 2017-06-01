module cubeWithVerticalFillets(length, width, height, radius)
{
    diameter = radius * 2;
    translate([radius, radius, 0])
	{
        minkowski()
		{
            cube([length - diameter, width - diameter, height / 2]);
            cylinder(r = radius, h = height / 2);
        } 
    }
}

module cubeWithXHorizontalFillets(length, width, height, radius)
{
    diameter = radius * 2;
    translate([0, radius / 2, radius / 2])
	{
        minkowski()
		{
            cube([length / 2, width - radius, height - radius]);
            rotate(a = 90, v = [0, 1, 0]) cylinder(r = radius / 2, h = length / 2);
        } 
    }
}

module cubeWithVerticalFilletsRadialWidth(length, width, height)
{
    hull()
    {
        translate([width / 2, width / 2 , 0]) cylinder(d = width, h = height);
        translate([length - (width / 2), width / 2, 0]) cylinder(d = width, h = height);
    } 
}

module hexagonWithFillets(height, radius, filletRadius)
{
    hull()
	{
        rotate(a = 60, v = [0, 0, 1]) translate([radius - filletRadius, 0, 0]) cylinder(h = height, r = filletRadius);
        rotate(a = 120, v = [0, 0, 1]) translate([radius - filletRadius, 0, 0]) cylinder(h = height, r = filletRadius);
        rotate(a = 180, v = [0, 0, 1]) translate([radius - filletRadius, 0, 0]) cylinder(h = height, r = filletRadius);
        rotate(a = 240, v = [0, 0, 1]) translate([radius - filletRadius, 0, 0]) cylinder(h = height, r = filletRadius);
        rotate(a = 300, v = [0, 0, 1]) translate([radius - filletRadius, 0, 0]) cylinder(h = height, r = filletRadius);
        rotate(a = 360, v = [0, 0, 1]) translate([radius - filletRadius, 0, 0]) cylinder(h = height, r = filletRadius);
    }
}


function calculateBodyHeight(linearBearingHeight, GapBetweenLinearBearings) = (linearBearingHeight * 2) + GapBetweenLinearBearings;

module checkBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods)
{
    linearBearingBodyHeight = ((linearBearingHeight * 2) + GapBetweenLinearBearings);
    smoothRodBodyHeight = ((smoothRodRadius * 2) + distanceBetweenSmoothRods + 6);
    if(linearBearingBodyHeight < smoothRodBodyHeight)
	{
        echo(str("<font color=\"red\"><b><br>Warning: Body height calculated from linear bearing values is shorter than height calculated from smooth rod values<br>linearBearingBodyHeight=",linearBearingBodyHeight,"<br>smoothRodBodyHeight=",smoothRodBodyHeight,"<br></b></font>"));
    }
}



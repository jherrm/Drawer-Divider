include <../MCAD/boxes.scad>

// Drawer Divider v1.0
// Print drawer dividers for your storage cabinet.

// Copyright (c) 2012 Jeremy Herrman ( @jherrm, http://jherrman.com )
// Licensed under the MIT license.
// http://www.opensource.org/licenses/mit-license



// These values work for the small drawers on a Stack-On 39/22-Drawer Storage Cabinet
// http://www.lowes.com/pd_124553-941-DSB-39_
thickness = 1.5;
widthTop = 51;    widthBottom = 50;
heightLeft = 33;  heightRight = 33;
cornerRadiusTopLeft = 1;    cornerRadiusTopRight = 1;
cornerRadiusBottomLeft = 3; cornerRadiusBottomRight = 3;

// A single drawer divider
DrawerDivider(widthTop, widthBottom,
				heightLeft, heightRight,
				thickness,
				cornerRadiusTopLeft, cornerRadiusTopRight,
				cornerRadiusBottomLeft, cornerRadiusBottomRight);

/*
// A four pack for printing lots of dividers
rotate([0, 0, 0]) {
	twoPack(widthTop, widthBottom,
		   heightLeft, heightRight,
		   thickness,
		   cornerRadiusTopLeft, cornerRadiusTopRight,
		   cornerRadiusBottomLeft, cornerRadiusBottomRight);
}
rotate([0, 0, 180]) {
	twoPack(widthTop, widthBottom,
		   heightLeft, heightRight,
		   thickness,
		   cornerRadiusTopLeft, cornerRadiusTopRight,
		   cornerRadiusBottomLeft, cornerRadiusBottomRight);
}
*/


// Creates two drawer dividers, each facing different directions so that
// we can fit more on a build platform.
module twoPack(widthTop, widthBottom,
				   heightLeft, heightRight,
				   thickness,
				   cornerRadiusTopLeft, cornerRadiusTopRight,
				   cornerRadiusBottomLeft, cornerRadiusBottomRight) {

	// To fit 4 dividers on a cupcake's build platform,
	// we need to tighten up the spacing a bit
	horizontalSpacingX = -5;
	horizontalSpacingY =  10;
	verticalSpacingX = -6;
	verticalSpacingY =  8;

	// Create the first drawer divider
	rotate([0, 0, 0]) {
		translate([max(widthTop, widthBottom)/2 + horizontalSpacingX, max(heightLeft, heightRight)/2 + horizontalSpacingY, 0]) {
			DrawerDivider(widthTop, widthBottom,
							heightLeft, heightRight,
							thickness,
							cornerRadiusTopLeft, cornerRadiusTopRight,
							cornerRadiusBottomLeft, cornerRadiusBottomRight);
		}
	}

	rotate([0, 0, 90]) {
		translate([max(widthTop, widthBottom)/2 + verticalSpacingX, max(heightLeft, heightRight)/2 + verticalSpacingY, 0]) {
			DrawerDivider(widthTop, widthBottom,
							heightLeft, heightRight,
							thickness,
							cornerRadiusTopLeft, cornerRadiusTopRight,
							cornerRadiusBottomLeft, cornerRadiusBottomRight);
		}
	}
}

module DrawerDivider(widthTop, widthBottom,
					   heightLeft, heightRight,
					   thickness,
					   cornerRadiusTopLeft, cornerRadiusTopRight,
					   cornerRadiusBottomLeft, cornerRadiusBottomRight
				   ) {

	// Cutout the top center to allow drawer to open past divider
	widthCutout = 22;
	heightCutout = 5;
	cornerRadiusCutout = 2;

	translate([0, 0, thickness/2]) { // lie down flat on the print platform
		difference() {
			// Create the main drawer divider body
			RoundedRect(widthTop, widthBottom,
						heightLeft, heightRight,
						thickness,
						cornerRadiusTopLeft, cornerRadiusTopRight,
						cornerRadiusBottomLeft, cornerRadiusBottomRight);

			// Create the cutout in the top center of the divider
			// If you don't need a cutout, comment out this portion
			translate([-max(widthCutout, widthCutout)/2, max(heightLeft, heightRight)/2, 0]) {
				RoundedRect(widthCutout, widthCutout,
							heightCutout, heightCutout,
							thickness + 1, // + 1 for openscad rendering bug
							cornerRadiusCutout, cornerRadiusCutout,
							cornerRadiusCutout, cornerRadiusCutout, false);

				// Cut out edges left by rounded corners on the top
				translate([0,-heightCutout/2,-thickness+1/2]) cube([widthCutout, heightCutout/2+1, thickness+1], false);
			}
		}
	}
}

// Generic rounded rectangle capable of having different sized sides and
// different roundness on each corner.
module RoundedRect(widthTop, widthBottom,
				   heightLeft, heightRight,
				   thickness,
				   cornerRadiusTopLeft, cornerRadiusTopRight,
				   cornerRadiusBottomLeft, cornerRadiusBottomRight,
				   center = true) {

	seg = 100;
	width = widthTop;

	if(center)
	{
		translate([-max(widthTop, widthBottom)/2, max(heightLeft, heightRight)/2, 0]) {
			_RoundedRect(widthTop, widthBottom,
				   heightLeft, heightRight,
				   thickness,
				   cornerRadiusTopLeft, cornerRadiusTopRight,
				   cornerRadiusBottomLeft, cornerRadiusBottomRight);
		}
	}
	else {
		_RoundedRect(widthTop, widthBottom,
		   heightLeft, heightRight,
		   thickness,
		   cornerRadiusTopLeft, cornerRadiusTopRight,
		   cornerRadiusBottomLeft, cornerRadiusBottomRight);
	}
}

// The place where the actual rounded rectangle gets created.
module _RoundedRect(widthTop, widthBottom,
				   heightLeft, heightRight,
				   thickness,
				   cornerRadiusTopLeft, cornerRadiusTopRight,
				   cornerRadiusBottomLeft, cornerRadiusBottomRight) {
	seg = 100; // the segmentation resolution of the corners

	// Extrude the rounded rectangle
	linear_extrude(height = thickness, center = true, convexity = 10, twist=0) {
		// Form a hull around the four corners
		hull() {
			// Create the top left corner
			translate([cornerRadiusTopLeft, -cornerRadiusTopLeft, 0]) {
				circle(cornerRadiusTopLeft, $fn=seg);
			}
			// Create the top right corner
			translate([widthTop - cornerRadiusTopRight, -cornerRadiusTopRight, 0]) {
				circle(cornerRadiusTopRight, $fn=seg);
			}
			// Create the bottom left corner
			translate([widthTop/2 - widthBottom/2 + cornerRadiusBottomLeft, -heightLeft + cornerRadiusBottomLeft, 0]) {
				circle(cornerRadiusBottomLeft, $fn=seg);
			}
			// Create the bottom right corner
			translate([widthTop/2 + widthBottom/2 - cornerRadiusBottomRight, -heightRight + cornerRadiusBottomRight, 0]) {
				circle(cornerRadiusBottomRight, $fn=seg);
			}
		}
	}
}

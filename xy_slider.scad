include <BOSL2/std.scad>;

// about the Y-Axis rails
rail_sep = 52;
rail_d = 8;

idler_bolt_d = 4.2;
idler_pos = [-6, 0];
idler_pulley_clearance_d = 20;
belt_sep_around_pulley = 18;

bearing_d = 15;
bearing_l = 25;
bearing_center_xcoord = -30;
bearing_sep = 10; // distance between bearings

block_w = 48; // in x
block_l = rail_sep+25; // in y
block_t = 14; // in z

stepper_hole_sep = 31;
stepper_shaft_clearance_d = 22+5;
stepper_hole_d = 3.5;

screw_d = 3.5;

$fn = 60;

top_or_bottom = BOTTOM; // TOP or BOTTOM
make_xy_slider(false, top_or_bottom); // no motor
back(100) make_xy_slider(true, top_or_bottom); // with motor

module make_xy_slider(motor, top_or_bottom) {
	difference() {
		union() {
			cuboid(
				[block_w, block_l, block_t],
				anchor=RIGHT,
				rounding=3, except=[TOP,BOTTOM]
			);

			if (motor) {
				cuboid(
					[stepper_hole_sep/2+5, stepper_hole_sep+10, block_t],
					anchor=LEFT,
					rounding=3, except=[TOP,BOTTOM, LEFT]
				);
			}
			else {
				
			}
		}

		// remove Y-Axis rails
		right(bearing_center_xcoord)
			for(y = [1,-1]) fwd(y*rail_sep/2) xcyl(d=rail_d, h=100, anchor=LEFT);

		// remove X-Axis rail
		right(bearing_center_xcoord) ycyl(d=rail_d+1.5, h=100);

		// remove X-Axis bearings
		right(bearing_center_xcoord) for(y = [1,-1])
			fwd(y*(bearing_l/2+bearing_sep/2)) ycyl(d=bearing_d, h=bearing_l);

		if (motor) {
			// remove motor screw holes
			for (x = [1,-1]) for (y = [1,-1])
			translate([x*stepper_hole_sep/2, y*stepper_hole_sep/2, 0])
				zcyl(d=stepper_hole_d, h=100);

			// remove stepper shaft/area
			zcyl(d=stepper_shaft_clearance_d, h=100);

			// remove part out to the right of the motor
			up(1) cuboid([100, belt_sep_around_pulley, 100], anchor=LEFT+BOTTOM);
		}
		else {
			// remove place for idler pulley
			up(1) translate(idler_pos) {
				cuboid([100, belt_sep_around_pulley, 100], anchor=LEFT+BOTTOM);
				zcyl(d=belt_sep_around_pulley, h=100, anchor=BOTTOM);
			}

			// remove idler pulley screw
			translate(idler_pos) zcyl(d=idler_bolt_d, h=100);
		}

		// remove screw holes to screw it all together
		for (y = [1,-1])
		for (xy = [
				[bearing_center_xcoord-13, 25], // near bearing
				[bearing_center_xcoord-13, 0], // near bearing
				if (!motor) [bearing_center_xcoord+8, 0], // near bearing
				[-10, rail_sep/2+8], // near rails
				if (!motor) [-10, rail_sep/2-8] // near rails
			
			])
			translate([xy[0], y*xy[1], 0])
				zcyl(d=screw_d, h=100);


		// remove top or bottom
		cuboid([500, 500, 100], anchor=top_or_bottom);
		
	}

	// add tiny peg for idler pulley
	if (!motor && top_or_bottom==TOP) difference() {
		// add little idler add-on
		translate(idler_pos) zcyl(d=8, h=2, anchor=BOTTOM);
		// add little idler add-on
		translate(idler_pos) zcyl(d=idler_bolt_d, h=100);
	}
  
}


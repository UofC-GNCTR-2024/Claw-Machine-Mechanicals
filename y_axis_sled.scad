include <BOSL2/std.scad>;

// about the Y-Axis rails
rail_sep = 52;
rail_d = 8;

belt_sep_around_pulley = 18;

bearing_d = 15;
bearing_l = 25;
bearing_sep = 4; // distance between bearings

block_w = 60; // in x
block_l = rail_sep+30; // in y
block_t = 14; // in z

stepper_hole_sep = 31;
stepper_shaft_clearance_d = 22+5;
stepper_hole_d = 3.5;

split_size = 3;

nut_w = 5.5 + 0.5;
nut_t = 2.4 + 0.3;

nut_w_tight = 5.5-0.1;

screw_d = 3.5;

gearbox_d = 25 - 0.4;
gearbox_l = 19 - 1;
pulley_od_max = 45;

$fn = 60;

make_y_sled(TOP);
//make_y_sled(BOTTOM);
//back(100) make_y_sled(BOTTOM); // for preview

module make_y_sled(top_or_bottom) {
	difference() {
		union() {
			cuboid(
				[block_w, block_l, block_t],
				anchor=CENTER,
				rounding=3, except=[TOP,BOTTOM]
			);

			// add on holder for gearbox
			down(block_t/2) cuboid(
				[gearbox_l, gearbox_d + 20, pulley_od_max/2+gearbox_d/2+5],
				anchor=TOP,
				rounding=3, except=[TOP]
			);

		}

		// remove Y-Axis rails
		for(y = [1,-1]) fwd(y*rail_sep/2) {
			// rails
			xcyl(d=rail_d+1.5, h=100, anchor=CENTER);

			// bearings
			for(x = [1,-1])
			left(x*(bearing_l/2+bearing_sep/2)) xcyl(d=bearing_d, h=bearing_l);
		}

		// remove bolts to hold the top and middle parts together
		for (x = [1,-1,0]) for (y = [1,-1]) for (side = (x==0 ? [1] : [1,-1]))
		translate([x*18, y*(rail_sep/2 + 11*side), 0]) {
			// screw hole
			zcyl(d=screw_d, h=100);

			// nut on top side
			up(block_t/2 - nut_t)
			zcyl(r=nut_w_tight/sqrt(3), h=20, anchor=BOTTOM, $fn=6);
		}

		// remove gearbox
		down(block_t/2 + pulley_od_max/2) xcyl(d=gearbox_d, h=100);

		// remove nut and bolt to secure gearbox
		fwd(17) {
			zcyl(d=screw_d, h=100);

			// nut access
			for (z = [-block_t/2-pulley_od_max/2+10, /*-block_t/2-pulley_od_max/2-10*/]) up(z)
			hull() {
				zrot(30) zcyl(r=nut_w/sqrt(3), h=nut_t, $fn=6, anchor=CENTER);
				fwd(100) zrot(30) zcyl(r=nut_w/sqrt(3), h=nut_t, $fn=6, anchor=CENTER);
			}
		}

		// remove the split to tighten on the gearbox
		down(block_t/2 + pulley_od_max/2) cuboid(
			[100, 100, split_size],
			anchor=BACK
		);


		// remove top or bottom
		cuboid([500, 500, 100], anchor=top_or_bottom);

		// remove slit in top to pass belt through
		up(-0.5) {
			cuboid(
				[150, 22, 100],
				anchor=BOTTOM
			);
			// cuboid(
			// 	[26, 15, 100],
			// 	anchor=BOTTOM+FRONT
			// );
		}
		
	}

	// import the belt holder
	//if (top_or_bottom == TOP)
	//	up(3.5) fwd(31) import("gt2_belt_coupler.stl");

}


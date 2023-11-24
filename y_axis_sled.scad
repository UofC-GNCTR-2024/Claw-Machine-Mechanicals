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

gearbox_bolt_d = 3.2;
gearbox_bolt_meat = 2; // meat of wall to pass through
gearbox_bolt_head_d = 6 + 0.8;
gearbox_bolt_sep_a = 18;
gearbox_bolt_sep_b = 33;
gearbox_dist_top_bolts_to_shaft = 9;
gearbox_len_a = 32;
gearbox_len_b = 46;
gearbox_h = 23.5;
gearbox_shaft_hole_d = 10;
gearbox_plate_t_in_y_pretend = 5;
gearbox_plate_t_in_x = 3.5;
bot_plate_t = 3;

gearbox_block_l = 60;
gearbox_block_shift_fwd = 2;

pulley_od_max = 50;
pulley_len = 20;

pulley_support_bolt_d = 6.1;
pulley_support_nut_w = 10+0.5;

cord_d = 6;
cord_torus_d_min = 5;

$fn = 60;

//make_y_sled(TOP);
//back(100) make_y_sled(BOTTOM); // for preview

make_y_sled(BOTTOM);
//back(100) make_y_sled(TOP); // for preview

module make_y_sled(top_or_bottom) {
	difference() {
		union() {
			cuboid(
				[block_w, block_l, block_t],
				anchor=CENTER,
				rounding=3, except=[TOP,BOTTOM]
			);

			// add on holder for gearbox
			down(block_t/2) fwd(gearbox_block_shift_fwd) cuboid(
				[
					pulley_len + 2*gearbox_plate_t_in_x,
					gearbox_block_l,
					pulley_od_max + bot_plate_t // /2 + gearbox_len_a/2 + 5
				],
				anchor=TOP,
				rounding=3, except=[TOP]
			);

		}

		// remove gearbox screw holes
		down(block_t/2 + pulley_od_max/2)
		for (y=[1,-1]) for (z=[1,-1])
		down(z*gearbox_bolt_sep_a/2)
		fwd(gearbox_dist_top_bolts_to_shaft + y*gearbox_bolt_sep_b/2) {
			// motor side
			xcyl(d=gearbox_bolt_d, h=100, anchor=LEFT);

			// screw driver and screw head
			right(pulley_len/2 + gearbox_plate_t_in_x-gearbox_bolt_meat) xcyl(d=gearbox_bolt_head_d, h=100, anchor=RIGHT);
		}
		

		// remove motor axis hole, support hole
		down(block_t/2 + pulley_od_max/2) {
			// motor axis hole out +X
			xcyl(d=gearbox_shaft_hole_d, h=100, anchor=LEFT);

			// support bolt hole (M6) out -X
			xcyl(d=pulley_support_bolt_d, h=100, anchor=RIGHT);

			// support bolt nut (M6) out -X
			xcyl(
				r=pulley_support_nut_w/sqrt(3),
				h=pulley_len/2 + 2.3,
				$fn=6,
				anchor=RIGHT
			);
		}

		// remove where pulley goes (as a cyl)
		// hull() {
		// 	down(block_t/2 + pulley_od_max/2)
		// 	xcyl(d=pulley_od_max, h=pulley_len, anchor=CENTER);

		// 	down(400)
		// 	xcyl(d=pulley_od_max, h=pulley_len, anchor=CENTER);
		// }

		// remove where pulley goes (as a box, all the way through)
		if (top_or_bottom == BOTTOM)
		for (y = [0, gearbox_block_shift_fwd+2]) fwd(y)
		cuboid(
			[pulley_len, pulley_od_max, 400],
			anchor=CENTER
		);

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

	// add the torus for the cord, and its supports
	if (top_or_bottom == BOTTOM) {
		difference() {
			intersection() {
				union() {
					
					// make the X
					down(block_t/2 + pulley_od_max)
					for (x = [1, -1]) for (y = [1, -1])
					hull() {
						// center one
						zcyl(d=12, h=bot_plate_t, anchor=TOP);

						// out ones
						translate([x*20, y*30])
						zcyl(d=6, h=bot_plate_t, anchor=TOP, $fn=8);
					}
				}

				// intersect with gearbox block
				down(block_t/2) fwd(gearbox_block_shift_fwd) cuboid(
					[
						pulley_len + 2*gearbox_plate_t_in_x,
						gearbox_block_l,
						pulley_od_max + bot_plate_t // /2 + gearbox_len_a/2 + 5
					],
					anchor=TOP,
					rounding=3, except=[TOP]
				);
			}

			// remove hole for cord
			zcyl(d=cord_d + cord_torus_d_min, h=200);
		}

		
		// make the torus for the cord
		down(block_t/2 + pulley_od_max + bot_plate_t/2)
		torus(
			d_min = cord_torus_d_min,
			id = cord_d - 0.5
		);
	} // END if (top_or_bottom == BOTTOM)


	// import the belt holder
	//if (top_or_bottom == TOP)
	//	up(3.5) fwd(31) import("gt2_belt_coupler.stl");

}


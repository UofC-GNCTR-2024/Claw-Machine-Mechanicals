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
stepper_hole_d = 3.5;

split_size = 3;

nut_w = 5.5 + 0.5;
nut_t = 2.4 + 0.3;

nut_w_tight = 5.5-0.1;

screw_d = 3.5;
screw_head_d = 6;

gearbox_bolt_d = 3.2;
gearbox_bolt_meat = 2; // meat of wall to pass through
gearbox_bolt_head_d = 6 + 0.8;
gearbox_bolt_sep_a = 18;
gearbox_bolt_sep_b = 33;
gearbox_dist_top_bolts_to_shaft = 9;
gearbox_len_a = 32;
gearbox_len_b = 46;
gearbox_h = 23.5;
gearbox_shaft_hole_d = 10; // from pulley base_diameter
gearbox_plate_t_in_y = 2.5;
gearbox_plate_t_in_x = 3.5;
bot_plate_t = 3;

pulley_od_max = 50;
pulley_len = 22; // height with no retainer_lip is 22

// for supporting the OD of the pulley in the -X side
pulley_support_d = 46+0.5;
pulley_support_nut_w = 1; //unused
pulley_frictional_support_wall_t = 3;
pulley_frictional_support_len = 14; // len past edge of block

cord_d = 6;
cord_torus_d_min = 5;
cord_torus_offset = 10; // diameter of main part of pulley, divided by 2, plus a bit to get it close to a limit switch

gearbox_block_w = pulley_len + 2*gearbox_plate_t_in_x;
gearbox_block_l = pulley_od_max + gearbox_plate_t_in_y*2;
gearbox_block_h = max(
					pulley_od_max,
					pulley_od_max/2 + gearbox_len_b - gearbox_dist_top_bolts_to_shaft
				) + bot_plate_t;


limit_screw_d = 1.9; // M2 thread-forming
limit_screw_l = 8;
limit_screw_sep = 10;

// z-protection tube to prevent lifting the z-axis too high
zprot_tube_od = gearbox_block_w; // 39ish would be ideal, but can't be bigger than gearbox_block_w
zprot_tube_len = 40; // get it past the sticking-out motor

$fn = 60;

// make_y_sled(TOP);
//back(100) make_y_sled(BOTTOM); // for preview

make_y_sled(BOTTOM);
// back(100) make_y_sled(TOP); // for preview

module make_y_sled(top_or_bottom) {
	difference() {
		union() {
			cuboid(
				[block_w, block_l, block_t],
				anchor=CENTER,
				rounding=3, except=[TOP,BOTTOM]
			);

			// add on holder block for gearbox
			down(block_t/2) cuboid(
				[
					gearbox_block_w,
					gearbox_block_l,
					gearbox_block_h
				],
				anchor=TOP,
				rounding=3, except=[TOP]
			);

			// add on support on bottom side for around the linear bearings
			down(block_t/2)
			cuboid(
				[
					gearbox_block_w + 2*3,
					rail_sep + 2*7,
					6
				],
				anchor=TOP,
				rounding=3, except=[TOP]
			);

			// add on extra pulley holder (cyl in -X)
			down(block_t/2 + pulley_od_max/2) {
				// pulley round frictional support out -X
				xcyl(
					d=pulley_support_d + 2*pulley_frictional_support_wall_t,
					h=gearbox_block_w/2 + pulley_frictional_support_len,
					anchor=RIGHT,
					$fn=(pulley_support_d>20?150:20)
				);
			}

			// add on support around bottom gearbox screw holes for printability
			down(block_t/2 + pulley_od_max/2)
			for (y=[1,0]) for (z=[1,-1])
			fwd(z*gearbox_bolt_sep_a/2)
			down(-gearbox_dist_top_bolts_to_shaft + y*gearbox_bolt_sep_b) {
				xcyl(
					d=gearbox_bolt_head_d + 2*3,
					h=gearbox_block_w/2 + pulley_frictional_support_len,
					anchor=RIGHT,
				);
			}

			// add on some quick zip tie holes (on gearbox)
			down(block_t/2 + pulley_od_max/2 + 30) {
				// on +Y face
				back(gearbox_block_l/2 + 2.5) {
					left(10)
					yrot(90)
					torus(id=6, d_min = 4);

					right(10)
					yrot(90)
					torus(id=6, d_min = 4);
				}

				// on +X and -X
				back(gearbox_block_l/2 - 10) {
					// +X
					right(gearbox_block_w/2)
					xrot(90)
					torus(id=6, d_min = 4);
					
					// -X
					left(gearbox_block_w/2)
					xrot(90)
					torus(id=6, d_min = 4);
				}
			}

			// for around M3 nut to hold it in
			down(block_t/2 + pulley_od_max/2) {
				left(gearbox_block_w/2 + 10) {
					ycyl(d=10, h=pulley_support_d + 2*8);
				}
			}
		}

		// remove gearbox screw holes
		down(block_t/2 + pulley_od_max/2)
		for (y=[1,0]) for (z=[1,-1])
		fwd(z*gearbox_bolt_sep_a/2)
		down(-gearbox_dist_top_bolts_to_shaft + y*gearbox_bolt_sep_b) {
			// motor side
			xcyl(d=gearbox_bolt_d, h=100, anchor=LEFT);

			// screw driver and screw head
			right(pulley_len/2 + gearbox_plate_t_in_x-gearbox_bolt_meat) xcyl(d=gearbox_bolt_head_d, h=100, anchor=RIGHT);
		}
		

		// remove motor axis hole, support hole
		down(block_t/2 + pulley_od_max/2) {
			// motor axis hole out +X
			xcyl(d=gearbox_shaft_hole_d, h=100, anchor=LEFT);

			// pulley round frictional support out -X
			xcyl(d=pulley_support_d, h=100, anchor=RIGHT, $fn=(pulley_support_d>20?150:20));

			// motor screw head access out +Y
			// optional; looks worse, but easier repair
			right(pulley_len/2 - 2)
			ycyl(d=4.2, h=100, anchor=FRONT);

			// remove screw hole in the pulley_frictional_support to really lock the pulley in
			// (prevents failure where the pulley falls out)
			left(gearbox_block_w/2 + 10) {
				
				// horizontal M3 with 2 separate bolts/recessed nuts
				ycyl(d=3.2, h=100);
				ycyl(r=5.5/sqrt(3), h=pulley_support_d + 2*4, $fn=6);

				// slightly rotated M4 with nylock
				xrot(25) {
					ycyl(d=4.2, h=100);
					
					back(pulley_support_d/2 + 1)
					ycyl(r=7/sqrt(3), h=100, anchor=FRONT, $fn=6);
				}
			}
		}

		// remove where pulley goes (as a cyl)
		// hull() {
		// 	down(block_t/2 + pulley_od_max/2)
		// 	xcyl(d=pulley_od_max, h=pulley_len, anchor=CENTER);

		// 	down(400)
		// 	xcyl(d=pulley_od_max, h=pulley_len, anchor=CENTER);
		// }

		// remove where pulley goes (as a box, all the way through in Z)
		if (top_or_bottom == BOTTOM)
		cuboid(
			[pulley_len, pulley_od_max, 400],
			anchor=CENTER
		);

		// remove limit switch mounting holes
		// for (rot = [0,90]) zrot(rot)
		// down(block_t/2 + gearbox_block_h - 5)
		// ycopies(spacing = 10, n = (rot==0 ? 6 : 2)) {
		// 	// screw hole
		// 	xcyl(d=limit_screw_d, h=100, anchor=CENTER, $fn=20);
		// }

		// remove Y-Axis rails
		for(y = [1,-1]) fwd(y*rail_sep/2) {
			// rails
			xcyl(d=rail_d+1.5, h=100, anchor=CENTER);

			// bearings
			for(x = [1,-1])
			left(x*(bearing_l/2+bearing_sep/2)) xcyl(d=bearing_d, h=bearing_l);
		}

		// remove bolts to hold the top and middle parts together
		side = 1;
		for (x = [1,-1,0]) for (y = [1,-1]) //for (side = (x==0 ? [1] : [1,-1]))
		translate([x*18, y*(rail_sep/2 + 11*side), 0]) {
			// screw hole
			zcyl(d=screw_d, h=100);

			// screw head on bottom side (in theory not used at all)
			down(block_t/2 - 1)
			zcyl(d=screw_head_d, h=100, anchor=TOP);

			// nut on top side
			up(block_t/2 - nut_t)
			zcyl(r=nut_w_tight/sqrt(3), h=20, anchor=BOTTOM, $fn=6);
		}

		// remove top or bottom
		cuboid([500, 500, 100], anchor=top_or_bottom);

		// remove place to screw in the belt
		for (a = [-2,-1,0,1,2]) {
			translate([a * 7, (a%2 == 0 ? 1 : -1) * a - 10, 0]) {
				// bolt
				zcyl(
					d=screw_d,
					h=100,
					anchor=BOTTOM
				);
				
				// nut
				zcyl(
					r=nut_w_tight/sqrt(3),
					h=nut_t,
					anchor=BOTTOM,
					$fn=6
				);
			}
		}
		
	}

	// add the torus for the cord, and its supports
	if (top_or_bottom == BOTTOM) {
		difference() {
			union() {
				intersection() {
					fwd (cord_torus_offset)
					union() {
						
						// make the X/cross
						down(block_t/2 + gearbox_block_h)
						for (x = [1, -1]) for (y = [1, -1])
						hull() {
							// center one
							zcyl(d=12, h=bot_plate_t, anchor=BOTTOM);

							// out ones
							translate([x*20, y*30])
							zcyl(d=6, h=bot_plate_t, anchor=BOTTOM, $fn=8);
						}
					}

					// intersect with gearbox block
					down(block_t/2) cuboid(
						[
							pulley_len + 2*gearbox_plate_t_in_x,
							gearbox_block_l,
							gearbox_block_h
						],
						anchor=TOP,
						rounding=3, except=[TOP]
					);
				}

				// add on zprot_tube
				fwd (cord_torus_offset)
				down(block_t/2 + gearbox_block_h - bot_plate_t/2)
				zcyl(
					h=zprot_tube_len,
					d1=zprot_tube_od,
					d2=gearbox_block_w,
					anchor=TOP,
					rounding1=3,
					$fn=150
				);

			} // end union

			// remove hole for cord
			fwd (cord_torus_offset)
			zcyl(d=cord_d + cord_torus_d_min, h=500);
		}

		
		// make the torus for the cord (closer to motor)
		fwd (cord_torus_offset)
		down(block_t/2 + gearbox_block_h - bot_plate_t/2)
		torus(
			d_min = cord_torus_d_min,
			id = cord_d - 0.5
		);

		// make the torus for the cord (farther from motor: zprot_tube)
		fwd (cord_torus_offset)
		down(block_t/2 + gearbox_block_h - bot_plate_t/2
			+ zprot_tube_len - cord_torus_d_min/2)
		torus(
			d_min = cord_torus_d_min,
			id = cord_d - 0.5
		);
	} // END if (top_or_bottom == BOTTOM)


	// import the belt holder
	//if (top_or_bottom == TOP)
	//	up(3.5) fwd(31) import("gt2_belt_coupler.stl");

}


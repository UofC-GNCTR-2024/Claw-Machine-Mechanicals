include <BOSL2/std.scad>;

// Ends for X-Axis rails
// One set will have motors and limit switches, while the other end will be boring
// X-Y plane is the top of the machine

rail_d = 8;
rail_split_size = 3;

// Using M3 bolts and nuts
bolt_d = 3 + 0.3;
nut_w = 5.5 + 0.5;
nut_t = 2.4 + 0.3;

dist_top_to_rail_center = 30; // based on metal motor mount geometry

limit_screw_d = 1.9; // M2 thread-forming
limit_screw_l = 8;
limit_screw_sep = 10;

//stepper_hole_sep = 31;
//stepper_shaft_clearance_d = 22+5;

block_h = dist_top_to_rail_center+rail_d/2+4;

$fn = 60;

x_end_with_limit_switch();

module x_end_with_limit_switch() {
	difference() {
		union() {
			cuboid(
				[30, 30, block_h],
				anchor=TOP,
				rounding=2, except=[BOTTOM, TOP],
			);

		}

		// remove smooth rod
		down(dist_top_to_rail_center) ycyl(d=rail_d, h=100, anchor=CENTER);

		// remove split for rod
		down(dist_top_to_rail_center) cuboid(
			[100, 100, rail_split_size],
			anchor=RIGHT,
		);

		// remove mounting holes in left side
		for(y=[10, 0, -10]) for (z = [6, dist_top_to_rail_center-6]) translate([-10, y, -z]) {
			// screw hole
			zcyl(d=bolt_d, h=100, anchor=CENTER);

			// nut access
			hull() {
				zcyl(r=nut_w/sqrt(3), h=nut_t, $fn=6, anchor=CENTER);
				left(100) zcyl(r=nut_w/sqrt(3), h=nut_t, $fn=6, anchor=CENTER);
			}
		}

		// remove mounting holes in right side
		for(y=[10, 0, -10]) for (z = [6]) translate([10, y, -z]) {
			// screw hole
			zcyl(d=bolt_d, h=100, anchor=CENTER);

			// nut access
			hull() {
				zcyl(r=nut_w/sqrt(3), h=nut_t, $fn=6, anchor=CENTER);
				right(100) zcyl(r=nut_w/sqrt(3), h=nut_t, $fn=6, anchor=CENTER);
			}
		}

		// remove limit switch mounting holes
		for (x = [1,-1]) for (y = [1,-1])
		translate([x*limit_screw_sep/2, y*11, -block_h]) {
			// screw hole
			zcyl(d=limit_screw_d, h=limit_screw_l, anchor=BOTTOM);
		}

		// remove stepper motor mounting holes

	}

}

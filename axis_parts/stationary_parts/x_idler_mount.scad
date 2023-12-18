include <BOSL2/std.scad>

// FIXME: if we re-print, lower the motor and idler to straddle the rails

// dist from plywood to center of pulley (motor raiser thickness + mount dist)
pulley_h = 12 + 30;

extra_h_on_top = 8;

idler_screw_d = 5.5;
idler_nut_w = 8;
idler_screw_meat_passthrough = 7.6;

block_w = 25; //
block_l = 20; // in dir

// Using M3 bolts and nuts out the bottom (in the base)
bolt_d = 3 + 0.3;
nut_w = 5.5;
nut_t = 2.4 + 1;

xy_screws_base = [
	[-6, -17],
	[-6, 17],
	[16, 0],
];
base_t = 8;


$fn = 60;

make_x_idler_mount();
left(40) yflip() make_x_idler_mount();

module make_x_idler_mount() {
	difference() {
		union() {
			cuboid(
				[block_l, block_w, pulley_h+extra_h_on_top],
				anchor=BOTTOM,
				rounding=3, except=[BOTTOM]
			);

			// add little extra to separate pulley
			up(pulley_h) {
				ycyl(d=idler_screw_d+4, h=block_w/2+0.8, anchor=BACK);
			}

			// add base screws
			hull() {
				for(xy = xy_screws_base) translate([xy[0], xy[1], 0]) {
					zcyl(
						d=8.5, h=base_t,
						anchor=BOTTOM,
						rounding2=2
					);
				}
			}
		}

		// remove screw hole for idler
		fwd(block_w/2-idler_screw_meat_passthrough) up(pulley_h) {
			ycyl(d=idler_screw_d, h=100);

			// remove nut retainer
			ycyl(
				r1=idler_nut_w/sqrt(3), r2=(idler_nut_w+1)/sqrt(3),
				h=block_w-idler_screw_meat_passthrough + 0.1,
				anchor=FRONT, $fn=6
			);
		}

		// remove base screws and nuts
		for(xy = xy_screws_base) translate([xy[0], xy[1], 0]) {			
			// screw hole
			zcyl(
				d=bolt_d, h=100,
			);

			// nut
			up(base_t - nut_t) zcyl(
				r=nut_w/sqrt(3),
				h=100,
				anchor=BOTTOM, $fn=6
			);
		}
	}
}

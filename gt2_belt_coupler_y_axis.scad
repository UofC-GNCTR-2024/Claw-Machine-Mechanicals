// a modification of the gt2_belt_coupler.stl original file

include <BOSL2/std.scad>

rail_sep = 52;
rail_d = 8;

screw_d = 3.5;

add_height = 0; // was 4

nut_t = 2.4 + 0.3;
nut_w_tight = 5.5-0.1;

block_h = 9; // approx

peg_h = 3;
peg_w = 11.5; // in y
peg_l = 8;

$fn = 60;

make_y_axis_belt_coupler();

module make_y_axis_belt_coupler() {
	difference() {
		union() {
			imp();

			// extend height out bottom
			down(add_height)
			linear_extrude(add_height+1) projection(cut=false) imp();

			// extend height out top
			up(block_h)
			linear_extrude(peg_h)
			projection(cut=true) down(block_h-1) imp();


			// add peg
			cuboid(
				[peg_l, peg_w, 9+peg_h],
				anchor=BOTTOM
			);
		}

		// remove screw hole through center
		zcyl(
			d=screw_d,
			h=100,
		);

		// remove nut on top side
		up(block_h+peg_h - nut_t)
		zrot(30)
		zcyl(
			r=nut_w_tight/sqrt(3),
			h=100,
			anchor=BOTTOM,
			$fn=6
		);
	}
}

module imp() {
	import("gt2_belt_coupler.stl");
}


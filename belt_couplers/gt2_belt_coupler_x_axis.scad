// a modification of the gt2_belt_coupler.stl original file

include <BOSL2/std.scad>

rail_sep = 52;
rail_d = 8;

screw_d = 3.5;

block_h = 9; // approx

$fn = 60;

make_x_axis_belt_coupler();

module make_x_axis_belt_coupler() {
	difference() {
		union() {
			imp();

			// % up(block_h/2)
			// fwd(3) // shift it away from the 
			// xrot(90) torus(
			// 	d_min = rail_d,
			// 	d_maj = rail_sep,
			// 	$fn=200
			// );
		}

		// remove screw hole through center
		zcyl(
			d=screw_d,
			h=100,
		);
		
		// remove screw hole through center (for fun)
		up(block_h/2)
		ycyl(
			d=screw_d,
			h=100,
		);
		

		// remove the rails
		// for (x = [1,-1])
		// left(x*rail_sep/2)
		// zcyl(d=rail_d, h=100);

		// remove a torus bc toruses are fun
		up(block_h/2)
		fwd(3) // shift it away from the 
		xrot(90) torus(
			d_min = rail_d,
			d_maj = rail_sep,
			$fn=200
		);
	}
}

module imp() {
	import("gt2_belt_coupler.stl");
}


include <BOSL2/std.scad>;

/*
	* OD of Shaft: 4mm
	* Shaft Flat Part, from OD to key: 3.2mm
	* Shaft Length: 8mm
	* Shaft Collar Length: 3mm
*/

shaft_od = 4;
shaft_od_to_key = 3.2;
shaft_length = 8;

pulley_od = 30;
pulley_h = 18;

my_rope_hole_d = 5;

torus_r_min = 6; // can be around half of pulley_h

$fn = 60;

idler_pulley();

module idler_pulley() {
	difference() {
		union() {
			zcyl(
				d=pulley_od, h=pulley_h,
				anchor=BOTTOM
			);
		}
		
		// remove hole for shaft
		difference() {
			zcyl(
				d=shaft_od,
				h=50,
			);
			right(-shaft_od/2 + shaft_od_to_key) cuboid(100, anchor=LEFT);
			
		}

		// remove torus shape
		// doc: https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-torus
		up(pulley_h/2) torus(
			r_maj=pulley_od/2,
			r_min=torus_r_min,
		);

		
        // Remove my_rope_hole
        translate([5, 0, pulley_h/2]) ycyl(d=my_rope_hole_d, h=100);
	}



}


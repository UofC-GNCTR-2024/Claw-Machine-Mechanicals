include <BOSL2/std.scad>;

raise_dist = 12;
hole_d = 4.2;
hole_sep = 30;
outside_size = 50;

$fn = 80;

make_x_motor_mount_raiser();

module make_x_motor_mount_raiser() {
	difference() {
		cuboid(
			[outside_size, outside_size, raise_dist],
			anchor=BOTTOM,
			rounding=3, except=[TOP,BOTTOM],
		);

		for (x=[1,-1, 0]) for (y=[1, -1]) {
			translate([
				x*hole_sep/2,
				y*hole_sep/2,
			]) zcyl(d=hole_d, h=100);
		}
	}
  
}

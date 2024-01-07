include <BOSL2/std.scad>;

// mclaw_ = metal claw
mclaw_width_at_widest = 11 + 0.5;
mclaw_t = 2.5;
mclaw_scale_circle_at_tip = 0.7;

wall_t = 2;

//make_2d_tip_shape(); // DEBUG
% right(30) make_tip(); // PREVIEW
make_tip_flat_bottom();

$fn = 60;


module make_tip_flat_bottom() {
	difference() {
		down(0.8) // change as required (0 is good when xrot!=90)
		xrot(80) // change as required
		back(mclaw_width_at_widest/2*mclaw_scale_circle_at_tip+wall_t)
		make_tip();

		// slice off everything below the XY plane
		if (1)
		cuboid(
			[100, 100, 100],
			anchor=TOP
		);
	}

}

module make_tip() {
	difference() {
		union() {
			// create the outside of it
			down(mclaw_t/2)
			offset3d(wall_t)
			linear_extrude(mclaw_t)
			make_2d_tip_shape();

			// add on a better gripper
			chain_hull() {
				//linear_extrude(0.1) yscale(mclaw_scale_circle_at_tip) circle(d=mclaw_width_at_widest + 2*wall_t);
				down(mclaw_t/2)
				offset3d(wall_t)
				linear_extrude(mclaw_t)
				yscale(mclaw_scale_circle_at_tip) circle(d=mclaw_width_at_widest);

				up(2) fwd(4)
				sphere(d=4);
	
				up(3) fwd(5)
				sphere(d=3);

				up(6) fwd(6)
				sphere(d=2);
			}
		}

		// remove the actual claw hole
		down(mclaw_t/2)
		linear_extrude(mclaw_t)
		make_2d_tip_shape();

		// remove the part at the top that gets rounded
		back(18) cuboid([100, 100, 100], anchor=FRONT);
	}

}

// 2D shape of the tip of the metal bit
module make_2d_tip_shape() {
	hull() {
		yscale(mclaw_scale_circle_at_tip) circle(d=mclaw_width_at_widest);

		back(20) rect([9, 1]); // hardcoded estimates
	}
}

include <BOSL2/std.scad>;

top_wall_h = 100;

wall_t = 2;

wood_height = 90;

round_chute_target_h = 110;

chute_front_extra = 40;

general_overall_width = 200;

chute_joiner_y_list = [60, (60+180)/2, 180]; // along right side
chute_joiner_x_list = [80, (80+180)/2, 180]; // along back side

screw_d = 3.2;

$fn = 60;

////////////////////////////////////////////////////////
// Debugging Chuncks
// make_top_polygon_above_frame();
// make_top_polygon_below_frame();
//full_chute();
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Printable Chuncks
//make_top_printable_chunck();
make_chute_printable_chunck() // bottom part
////////////////////////////////////////////////////////

echo("Total full chute height:", top_wall_h+wood_height+round_chute_target_h);

module make_top_printable_chunck() {
	difference() {
		full_chute(draw_chute_joiners = false);

		down(wood_height)
		cuboid([400, 400, 400], anchor=TOP);
	}
}

module make_chute_printable_chunck() {
	difference() {
		full_chute(draw_chute_joiners = true);

		translate([-0.01, -0.01]) 
		down(wood_height+0.01)
		cuboid([general_overall_width+0.02, general_overall_width+0.02, 400], anchor=BOTTOM+LEFT+FRONT);
	}
}

module full_chute(draw_chute_joiners) {
	difference() {
		union() {
			// add part above frame
			linear_extrude(height = top_wall_h)
			make_top_polygon_above_frame();

			// add part below frame (non-curved, inline with the wood)
			down(wood_height)
			linear_extrude(wood_height)
			make_top_polygon_below_frame();

			// add curved chute and front extra
			down(wood_height)
			right(60) {
				// curved chute
				zscale(round_chute_target_h/general_overall_width)
				yrot(90)
				rotate_extrude(angle=90, $fn=240) {
					square([general_overall_width, 140]);
				}

				// out the front
				cuboid(
					[140, chute_front_extra, round_chute_target_h],
					anchor=LEFT+TOP+BACK
				);
			}
			
			
			// add chute joiners (right side)
			if (draw_chute_joiners)
			down(wood_height)
			for (y = chute_joiner_y_list) {
				back(y)
				right(general_overall_width) cuboid(
					[wall_t, 10, 30],
					anchor=LEFT,
					rounding=wall_t/2, except=LEFT
				);
			}

			// add chute joiners (back side)
			if (draw_chute_joiners)
			down(wood_height)
			for (x = chute_joiner_x_list) {
				right(x)
				back(general_overall_width - 42) cuboid(
					[10, 42+wall_t, 30],
					anchor=FRONT,
					rounding=wall_t/2, except=FRONT
				);
			}

			// add a bit to screw into the wood to hold the chute on (left side)
			// back(60)
			// down(wood_height)
			// cuboid(
			// 	[60+wall_t, 140, wall_t],
			// 	anchor=FRONT+LEFT+TOP,
			// 	rounding=6, except=[TOP, BOTTOM, RIGHT],
			// );
			// NOTE: Adds too much complexity with supports.

			
		}
	
		// remove inside of part above frame
		up(wall_t)
		linear_extrude(height = 120)
		offset(-wall_t) make_top_polygon_above_frame();

		// remove inside of part below frame (inline with the wood)
		down(wood_height - wall_t)
		linear_extrude(height = wood_height+10)
		offset(-wall_t) make_top_polygon_below_frame();

		// remove inside of curved chute and front extra
		down(wood_height+wall_t)
		right(60 + wall_t) {
			// curved part
			zscale((round_chute_target_h - 2*wall_t)/(general_overall_width - wall_t))
			yrot(90)
			rotate_extrude(angle=90, $fn=240) {
				square([general_overall_width - wall_t, 140 - 2*wall_t]);
			}

			// out the front
			cuboid(
				[140-2*wall_t, chute_front_extra, round_chute_target_h - 2*wall_t],
				anchor=LEFT+TOP+BACK
			);
		}

		// remove hole between the "part below frame (inline with wood)" and the chute
		down(wood_height)
		right(60 + wall_t)
		back(20+wall_t)
		cuboid(
			[140 - 2*wall_t, general_overall_width-2*wall_t-20, wall_t*2+1],
			anchor=LEFT+FRONT,
			rounding=1, except=[TOP, BOTTOM]
		);

		// remove holes from chute joiners (right side)
		down(wood_height-10)
		for (y = chute_joiner_y_list) {
			back(y)
			right(general_overall_width) xcyl(d=screw_d, h=10);
		}
		
		// remove holes from chute joiners (back side)
		down(wood_height-10)
		for (x = chute_joiner_x_list) {
			right(x)
			back(general_overall_width) ycyl(d=screw_d, h=10);
		}


		// remove holes to screw into the "wood_height" wood
		down(wood_height/2)
		for (iter_val = [80, 180]) {
			// along front, above chute
			right(iter_val)
			back(20/2)
			zcyl(d=screw_d, h=wood_height+2*wall_t+10);

			// along left
			back(iter_val)
			right(20/2)
			zcyl(d=screw_d, h=wood_height+2*wall_t+10);
		}
	}
}

module make_top_polygon_above_frame() {
	difference() {
		rect(
			[200, 200],
			anchor=FRONT+LEFT,
			rounding=3
		);

		// remove where wood is
		translate([-1, -1]) rect(
			[20+40+1, 20+40+1],
			anchor=FRONT+LEFT
		);
	}
}

module make_top_polygon_below_frame() {
	difference() {
		translate([20, 20]) rect(
			[200-20, 200-20],
			anchor=FRONT+LEFT,
			rounding=3
		);

		// remove where wood is
		translate([-1, -1]) rect(
			[20+40+1, 20+40+1],
			anchor=FRONT+LEFT
		);
	}
}

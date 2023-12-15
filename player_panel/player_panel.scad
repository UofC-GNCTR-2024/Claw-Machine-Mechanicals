// player_panel.scad

include <BOSL2/std.scad>

wood_h = 88; // height of wood on back side

yellow_button_d = 24;

// TODO: flashing button info

stick_d = 15;
stick_screw_sep_major = 85;
stick_screw_sep_minor = 40;
stick_plate_w_major = 97;
stick_plate_w_minor = 65;

stick_screw_d = 3.2;

// playing face sizes
face_width = 220; // limit by printer (X)
face_length = 160; // Y

face_angle = 10; // angle of the face

wall_t = 3;

// the back ("wood") is on the +Y side

player_panel();

module player_panel() {
    difference() {
        // draw the outside of the panel
        down(wood_h)
        xrot(-face_angle, cp=[0, face_length/2, wood_h])
        union() {
            difference() {
                player_panel_outline(face_width, face_length, wood_h);

                // remove the inside of it
                player_panel_outline(face_width - 2*wall_t, face_length - 2*wall_t, wood_h - wall_t);


                //////////////////////////////////////////////////////////
                // everything below this point is on the back           //
                // of the panel, and is the XZ plane (on the back wall) //
                //////////////////////////////////////////////////////////
                
                // remove screw holes
                for (z = [18, wood_h-18, wood_h/2]) up(z)
                xcopies(spacing = 85, n = 3) {
                    ycyl(d=3.2, h=300, anchor=FRONT);
                }

                // remove wire hole in middle
                up(wood_h/2)
                ycyl(d=25, h=300, anchor=FRONT);
            }

            // add back on bottom plate mounting hole blocks
            translate([face_width/2-wall_t, face_length/2-wall_t, 0]) {
                // TODO: hull this cube with a point higher up on the edge
                cuboid(
                    [10, 10, 10],
                    anchor=BOTTOM+RIGHT+BACK,
                    rounding=2, except=[TOP, BOTTOM, RIGHT, BACK],
                );
            } // FIXME: remove a hole, and put it in every corner; also check the length/width args around
        }

        ///////////////////////////////////////////////
        // everything below this point is on the top //
        // of the panel, and is the XY plane         //
        ///////////////////////////////////////////////

        // remove the holes for the buttons
        left(50) ycopies(spacing=40, n=3) {
            zcyl(d=yellow_button_d, h=25);
        }

        // remove the holes for the stick
        right(50) {
            // main hole
            zcyl(d=stick_d, h=25);

            // screw holes
            ycopies(spacing = stick_screw_sep_major, n = 2)
            xcopies(spacing = stick_screw_sep_minor, n = 2) {
                zcyl(d=stick_screw_d, h=25);
            }
        }

    }
        

}

module player_panel_outline(_face_width, _face_length, _back_side_h) {
    difference() {
        union() {
            
            hull() {
                // make the face on the front
                fwd(_face_length/2)
                cuboid(
                    [_face_width, 4, _back_side_h - (_face_length * tan(face_angle))],
                    anchor=BOTTOM+FRONT,
                    rounding=2, except=BOTTOM,
                );

                // make the face on the back
                back(_face_length/2)
                cuboid(
                    [_face_width, 4, _back_side_h],
                    anchor=BOTTOM+BACK,
                    rounding=2, except=BOTTOM,
                );

            }
        }
    }
}

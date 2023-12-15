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
        difference() {
            player_panel_outline(face_length, face_width, wood_h);

            // remove the inside of it
            player_panel_outline(face_length - 2*wall_t, face_width - 2*wall_t, wood_h - wall_t);


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

        ///////////////////////////////////////////////
        // everything below this point is on the top //
        // of the panel, and is the XY plane         //
        ///////////////////////////////////////////////

        // remove the holes for the buttons

    }
        

}

module player_panel_outline(_face_length, _face_width, _back_side_h) {
    difference() {
        union() {
            
            hull() {
                // make the face on the front
                fwd(_face_length/2)
                cuboid(
                    [_face_width, 4, _back_side_h - (_face_length * tan(face_angle))],
                    anchor=BOTTOM,
                    rounding=2, except=BOTTOM,
                );

                // make the face on the back
                back(_face_length/2)
                cuboid(
                    [_face_width, 4, _back_side_h],
                    anchor=BOTTOM,
                    rounding=2, except=BOTTOM,
                );

            }
        }
    }
}

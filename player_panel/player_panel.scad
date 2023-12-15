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

face_angle = 30; // angle of the face

// the back ("wood") is on the +Y side

player_panel();

module player_panel() {
    difference() {
        union() {
            // make the playing face
            cuboid(
                [face_width, face_length, 2],
                anchor=BOTTOM,
                rounding=2, except=TOP,
            );

            // make the face on the back
            back(face_length/2)
            xrot(face_angle)
            cuboid(
                [face_width, 4, wood_h],
                anchor=BOTTOM,
                rounding=2,
            );

            // make the face on the front
            fwd(face_length/2)
            //xrot(face_angle)
            cuboid(
                [face_width, 4, wood_h * cos(face_angle)],
                anchor=BOTTOM,
                rounding=2,
            );

            hull() {

            }
        }
    }
}
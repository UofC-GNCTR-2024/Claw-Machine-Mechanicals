// player_panel.scad

include <BOSL2/std.scad>

wood_h = 88; // height of wood on back side

yellow_button_d = 24;
flashing_button_d = 24;
flashing_button_major_d = 65; // clearance for the whole thing

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
plane_t = 3;
text_t = 1; // taken out of plane_t
label_text_size = 10;

// lcd size
lcd_l = 50.2 + 0.5;
lcd_w = 19 + 0.5;

$fn = 60;

// the back ("wood") is on the +Y side

// a little riser for the LCD screen
if (0) lcd_riser();

// for design
if (0) player_panel();

// for export
if (1) {
    xrot(170 - 0.25)
    xrot(face_angle, cp=[0, face_length/2, wood_h])
    up(wood_h)
    player_panel();
}

module lcd_riser() {
    h = 5;
    width = 8;

    difference() {
        cuboid(
            [lcd_l + 2*width, lcd_w + 2*width, h],
            anchor = BOTTOM,
        );

        cuboid(
            [lcd_l, lcd_w, 100]
        );

        cuboid(
            [16, 100, 3],
            anchor=BOTTOM+FRONT
        );
    }
}


module player_panel() {
    difference() {
        // draw the outside of the panel
        down(wood_h)
        xrot(-face_angle, cp=[0, face_length/2, wood_h])
        union() {
            difference() {
                player_panel_outline(face_width, face_length, wood_h);

                // remove the inside of it
                player_panel_outline(face_width - 2*wall_t, face_length - 2*wall_t, wood_h - plane_t);


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
                for (right_val = [-60, 0, 60]) right(right_val)
                up(wood_h/2)
                ycyl(d=25, h=300, anchor=FRONT);

                // add "Property of Pizza Planet Inc." text
                right(face_width/2 - 1)
                up(10)
                zrot(90)
                xrot(90)
                text3d(
                    "Property of Pizza Planet Inc.",
                    size=8, h=100, anchor=BOTTOM, center=true
                );
            }

            // add back on bottom plate mounting hole blocks
            for (xmir = [1, 0]) for (ymir = [1, 0]) mirror([xmir, 0, 0]) mirror([0, ymir, 0])
            translate([face_width/2-wall_t, face_length/2-wall_t, 0]) {
                // TODO: hull this cube with a point higher up on the edge
                difference() {
                    hull() {
                        cuboid(
                            [10, 10, 10],
                            anchor=BOTTOM+RIGHT+BACK,
                            rounding=2, except=[TOP, BOTTOM, RIGHT, BACK],
                        );

                        cuboid(
                            [0.1, 0.1, 30],
                            anchor=BOTTOM+RIGHT+BACK,
                            // rounding=2, except=[TOP, BOTTOM, RIGHT, BACK],
                        );

                    }

                    // remove screw hole
                    translate([-6, -6, 0]) zcyl(d=2.7, h=50, anchor=BOTTOM);

                }
            } // FIXME: remove a hole, and put it in every corner; also check the length/width args around
        }

        ///////////////////////////////////////////////
        // everything below this point is on the top //
        // of the panel, and is the XY plane         //
        ///////////////////////////////////////////////

        // remove the holes for the buttons
        left(80) {
            for (y = [55, -10, -50])
                fwd(y) zcyl(d=yellow_button_d, h=25);
        
            // "CLAW" text
            down(text_t)
            fwd(31)
            text3d("CLAW", size=label_text_size, h=100, anchor=BOTTOM, center=true, atype="ycenter");

            // Up/Down Arrow
            down(text_t)
            back(30)
            right(-18)
            scale(0.6) arrow(100);
        }

        
        // remove the holes for the stick
        back(10) right(70) {
            // main hole
            zcyl(d=stick_d, h=25);

            // screw holes
            ycopies(spacing = stick_screw_sep_major, n = 2)
            xcopies(spacing = stick_screw_sep_minor, n = 2) {
                zcyl(d=stick_screw_d, h=25);
            }

            // fake stick
            % zcyl(d=10, h=60, anchor=BOTTOM);
            % up(60) sphere(d=30);
        }

        // flashing button
        fwd(10) left(10) {
            // visual
            % zcyl(d=flashing_button_major_d, h=10, anchor=BOTTOM);

            // actual hole
            zcyl(d=flashing_button_d, h=25);

            // "START" text
            down(text_t)
            back(26) left(26)
            zrot(45) text3d("START", size=label_text_size, h=100, anchor=BOTTOM, center=true, atype="ycenter");

        }

        // LCD screen
        back(50) left(10) {
            cuboid(
                [lcd_l, lcd_w, 25],
            );
        }

        // general text at the bottom
        down(text_t)
        right(20) {
            fwd(55)
            text3d("UofC GNCTR 2024", size=10, h=100, anchor=BOTTOM, center=true, atype="ycenter");

            fwd(69) // nice
            text3d("\"Bogg Story\"", size=label_text_size, h=100, anchor=BOTTOM, center=true, atype="ycenter");
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
                    rounding=2, except=[BOTTOM, TOP],
                );

                // make the face on the back
                back(_face_length/2)
                cuboid(
                    [_face_width, 4, _back_side_h],
                    anchor=BOTTOM+BACK,
                    rounding=2, except=[BOTTOM, TOP],
                );

            }
        }
    }
}

// 3D arrow, centered on origin, pointing in both directions
module arrow(height) {
    arrow_body_l = 20;
    arrow_body_w = 5;

    arrow_head_w = 15;
    arrow_head_l = 15;

    linear_extrude(height = height) {

        // Arrow body
        rect([arrow_body_w, arrow_body_l], anchor=CENTER);

        for (i = [1, 0])
        mirror([0, i, 0]) 
        translate([0, arrow_body_l/2])
            polygon([[-arrow_head_w/2, 0], [arrow_head_w/2, 0], [0, arrow_head_l]]);
    }
}

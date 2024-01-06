include <BOSL2/std.scad>;

$fn = 60;

difference() {
    cuboid(
        [70, 70, 4],
        anchor=BOTTOM,
        rounding=8, except=[TOP, BOTTOM]
    );

    zcyl(d=10, h=100);
}

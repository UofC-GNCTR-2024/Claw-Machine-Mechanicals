# Claw-Machine-Mechanicals
Mechanical components, docs, and CAD for the UofC GNCTR 2024 claw machine game

## Bill of Materials - Bought
1. 4x 8mm Smooth Rails (650mm long)
2. 4x 8mm Linear Bearings (LM8UU)
    * Outside Diameter: 15mm
    * Length: 24mm
    * Similar [Purchase Link](https://www.aliexpress.com/item/1005004774546723.html) with dimensions
3. 1x 12V Geared DC Motor with Encoder
    * `12V, 280 RPM`
    * [Purchase Link](https://www.aliexpress.com/item/4001314473291.html)
    * OD of Gearbox: 24.6mm
    * Length of Motor and Gearbox: 58.2mm
    * Length of Gearbox: 19mm
    * Distance between M3 screw holes: 17mm
    * OD of Shaft: 4mm
    * Shaft Flat Part, from OD to key: 3.2mm
    * Shaft Length, excluding collar: 8mm
    * Shaft Collar Length: 3mm
4. 3x NEMA 17 Motors
5. Claw
    * Comes with rope
    * 12V solenoid drive

## Parts to Construct
1. Pulley for Z-Axis Rope (`idler_pulley.scad`)
2. Rail mounts to Top for X-Axis rails (`x_ends.scad`)
    * Also includes mount for the limit switchs
3. Slider between X-Axis and Y-Axis (`xy_slider.scad`)
    * Motor mount on one side, idler on the other
    * Grip to X-Axit belt
    * Linear Bearing holders for X-Axis
    * Rail holders for Y-Axis rails
    * Limit Switch Mount
4. Mount from Y-Axis linear bearings to the Z-Axis motor (`y_axis_sled.scad`)
5. Idlers for X-Axis (`x_end_idler.scad`)
6. Drag Chain (`drag_chain_link.scad`)


## Axis Definitions
1. X-Axis = parallel to the side with two separated motors/linear rails
2. Y-Axis = perpendicular to the side with two separated motors/linear rails (claw attaches to Y-Axis)
3. Z-Axis = raise and lower

TODO: add photo

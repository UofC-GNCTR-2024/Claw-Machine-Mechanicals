// Measurements for premade grommets
//
// Ikea FIXA saw diameters: 35mm, 64mm, 78mm
// Ikea Lack table thickness: 2" (50.8mm)

/* [Global] */

// Which part to print
part = "tube"; // [tube:Tube, nut:Nut, lid:Lid, all:All]

/* [Tube] */

// The diameter of the hole this thing is going to be inserted in
holeDiameter = 22;
// The measurement of the depth of the hole. Don't account for the size of the nut or top ring.
holeDepth = 12;
// Width of the block (The stop, the limit, the flat ring that touches the board). Added to the radius of the hole
blockWidth = 12;

/* [Nut] */

// Width of the nut ring. This is not the diameter. It is milimeters added to the radius of the hole
nutWidth = 33;
// Thickness of the nut
nutThickness = 3;

/* [Lid] */

// Lid thickness
lidThickness = 2;
// Lid clearance, to avoid it being too tight
lidClearance = 0.8;
// Lid hole width
lidHoleDiameter = 40;
// Lid hole distance to center. 0 means that the center of the circle of the hole is the center of the lid. >0 means smaller hole. <0 means bigger hole.
lidHoleShifting = 15;
// The length of the four legs of the lid. Increase it for higher friction
lidLegLength = 15;
// The thickness of the legs of the lid. Increase it for higher strength
lidLegsThickness = 3;

/* [Fine tuning] */

// Added length to the tube that will project from the nut
tubeExtraLength = 0;
// Thickness of the tube. The higher, the smaller the inner hole
tubeThickness = 2;
// Width of the screw thread
screwThreadWidth = 1.2;
// Depth of the screw thread. The higher, the smaller the tube
screwThreadDepth = 1.2;
// Number of threads of the screw
numberOfThreads = 3;
// The thickness of the block. Increasing it won't affect the length.
blockThickness = 1.6;
// Block type
blockType = "conic"; // [conic:Conic, cylindrical:Cylindrical]
// The sides of the polygon of the nut. If you prefer a cylinder, set a high number like 100
nutFaces = 8;
// Space between the nut and the screw, to avoid it being too tight and maybe unscrewable
nutClearance = 0.1;

/* [Hidden] */

// Length of the tube
tubeLength = holeDepth + nutThickness + blockThickness + tubeExtraLength;

tubeDiameter = holeDiameter - screwThreadDepth*2;
$fn = 100;

blockDiameter = holeDiameter + blockWidth*2;
blockDiameter2 = blockType == "conic" ? blockDiameter - 2 : blockDiameter;

nutHoleDiameter = holeDiameter + nutClearance;
nutDiameter = nutHoleDiameter + nutWidth;

tubeHoleDiameter = tubeDiameter - tubeThickness*2;
lidDiameter = tubeHoleDiameter + tubeThickness;


module grommet() {
  difference() {
    union() {
      screw_thread(h=tubeLength, d=tubeDiameter, n=numberOfThreads);
      tube();
      top();
    };
    // Main hole
    translate([0,0,-5])
      cylinder(h=tubeLength+10, d=tubeHoleDiameter);
    // To fit the lid
    translate([0,0,-1])
      cylinder(h=lidThickness+1, d=lidDiameter+lidClearance);
    // Instead of a flat border, I did it as a cone to make easier printable without support
    translate([0,0,lidThickness-0.01])
      cylinder(h=2, d1=lidDiameter+lidClearance, d2=tubeHoleDiameter);
  }
}


module nut() {
  difference() {
    cylinder(d=nutDiameter, h=nutThickness, $fn=nutFaces);
    translate([0,0,-1])
      cylinder(d=nutHoleDiameter, h=nutThickness+2);
  };
  nut_screw_thread();
}

module lid() {
    difference() {
        union() {
            cylinder(d=lidDiameter, h=lidThickness);
            // Lid legs
            difference() {
                translate([0, 0, lidThickness])
                union() {
                    cylinder(d=tubeHoleDiameter, h=lidLegLength);
                    translate([0,0, lidLegLength])
                      cylinder(d1=tubeHoleDiameter, d2=tubeHoleDiameter-lidLegsThickness*2/3, h=2);
                    cylinder(h=2, d1=lidDiameter, d2=tubeHoleDiameter);
                }
                translate([0,0,-tubeLength/4])
                    cylinder(d=tubeHoleDiameter-lidLegsThickness, h=tubeLength);
                translate([-50, -tubeHoleDiameter/4,0])
                    cube([100, tubeHoleDiameter/2, 100]);
                translate([-tubeHoleDiameter/4, -50, 0])
                    cube([tubeHoleDiameter/2, 100, 100]);
            }
        }
        // Lid hole
        translate([0,lidHoleShifting,-tubeLength/4])
            cylinder(d=lidHoleDiameter, h=tubeLength);
        translate([-lidHoleDiameter/2,lidHoleShifting,-tubeLength/4])
            cube([lidHoleDiameter, 1000, tubeLength]);
    }
}

module nut_screw_thread() {
  screw_thread(h=nutThickness, d=nutHoleDiameter, n=numberOfThreads);
}

module tube() {
  cylinder(h=tubeLength, d=tubeDiameter);
}

module top() {
  cylinder(d2=blockDiameter, d1=blockDiameter2, h=blockThickness);
}

module screw_thread(h, d, n) {
   // one per screw
  for(i=[0:n]) {
    rotate([0,0,360*i/n])
      extrude_path_dot(tmin=screwThreadWidth/2, tmax=h-screwThreadWidth/2, tstep=$fn*5, dotwidth=screwThreadWidth, dotdepth=screwThreadDepth, d=d);
  }
}

module extrude_path_dot(tmin, tmax, tstep, dotwidth, dotdepth, d){
  dt=(tmax-tmin)/tstep;
  for(t=[tmin:dt:tmax-dt]){
    hull(){
      screw_dot(t, dotwidth, dotdepth, d);
      screw_dot(t+dt, dotwidth, dotdepth, d);
    }
  }
}

module screw_dot(t, dotwidth, dotdepth, d){
  zrot=y(t);
  translate(x(t, d))
  scale([dotdepth, dotdepth, dotwidth/2])
  rotate([0,90,zrot])
    sphere(r=1, $fn=6);
}

function x(t, d)=[
  -sin(y(t)) * c(d),
  cos(y(t)) * c(d),
  t
];

function y(t)=t*360/(2*numberOfThreads*screwThreadWidth);//t*70;//
function c(d)=d/2;

if (part == "tube" || part == "all") {
  color([1,0,0])
    grommet();
}

if (part == "all") {
  translate([blockDiameter/2 + nutDiameter/2 + 5,0,0])
  color([0,1,0])
    nut();
  translate([0, blockDiameter/2 + holeDiameter/2 + 5, 0])
  color([0,0,1])
    lid();
}

if (part == "nut") {
  color([0,1,0])
    nut();
}

if (part == "lid") {
  color([0,0,1])
    lid();
}
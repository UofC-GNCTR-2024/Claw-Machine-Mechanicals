//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (08-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

include <library/YAPPgenerator_v30.scad>

//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-axis ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
      Y |                                        |    v
      | |    -5,y +----------------------+       |   ---              
 B    a |         | 0,y              x,y |       |     ^              F
 A    x |         |                      |       |     |              R
 C    i |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = false;
enablePCBPreview      = false;

//-- pcb dimensions -- very important!!!
pcbLength           = 158.115 - 24.765; // Front to back (Y on PCB), X on box
pcbWidth            = 213.36 - 50.8; // Side to side (X on PCB), Y on box
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall

paddingFront        = 8;
paddingBack         = 10;
paddingRight        = 10;
paddingLeft         = 5;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.6;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 25 + 5; // +standoffHeight
lidWallHeight       = 8;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 5.0;
ridgeSlack          = 0.2;
roundRadius         = 3.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 7;  //-- used for PCB Supports, Push Button and showPCB
standoffDiameter    = 8;
standoffPinDiameter = 2.7; // 2.7mm for M3 thread-forming screws
standoffHoleSlack   = 0; // orig: 0.4 (added to the PCB mounting hole diameter)

//-- C O N T R O L ---------------//-> Default -----------------------------
showSideBySide        = true;     //-> true
previewQuality        = 5;        //-> from 1 to 32, Default = 5
renderQuality         = 6;        //-> from 1 to 32, Default = 8
onLidGap              = 3;
shiftLid              = 5;
colorLid              = "YellowGreen";   
alphaLid              = 1;
colorBase             = "BurlyWood";
alphaBase             = 1;
hideLidWalls          = false;    //-> false
hideBaseWalls         = false;    //-> false
showOrientation       = true;
showPCB               = false;
showSwitches          = false;
showMarkersBoxOutside = false;
showMarkersBoxInside  = false;
showMarkersPCB        = false;
showMarkersCenter     = false;
inspectX              = 0;        //-> 0=none (>0 from Back)
inspectY              = 0;        //-> 0=none (>0 from Right)
inspectZ              = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack      = true;     //-> View from the inspection cut foreward
inspectYfromLeft      = true;     //-> View from the inspection cut to the right
inspectZfromTop       = false;    //-> View from the inspection cut down
//-- C O N T R O L -----------------------------------------------------------

//-------------------------------------------------------------------
//-------------------------------------------------------------------
// Start of Debugging config (used if not overridden in template)
// ------------------------------------------------------------------
// ------------------------------------------------------------------

//==================================================================
//  *** Shapes ***
//------------------------------------------------------------------
//  There are a view pre defines shapes and masks
//  shapes:
//      shapeIsoTriangle, shapeHexagon, shape6ptStar
//
//  masks:
//      maskHoneycomb, maskHexCircles, maskBars, maskOffsetBars
//
//------------------------------------------------------------------
// Shapes should be defined to fit into a 1x1 box (+/-0.5 in X and Y) - they will 
// be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-0.5,-0.5],[0,0.5],[0.5,-0.5]]];
// To see how to add your own shapes and mask see the YAPPgenerator program
//------------------------------------------------------------------


// Show sample of a Mask
//SampleMask(maskHoneycomb);

//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//   Optional:
//    p(2) = Height to bottom of PCB : Default = standoffHeight
//    p(3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    p(4) = standoffDiameter    Default = standoffDiameter;
//    p(5) = standoffPinDiameter Default = standoffPinDiameter;
//    p(6) = standoffHoleSlack   Default = standoffHoleSlack;
//    p(7) = filletRadius (0 = auto size)
//    n(a) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    n(b) = { yappHole, <yappPin> } // Baseplate support treatment
//    n(c) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }  
//    n(e) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = 
[
  // Example:
  //- Add stands 5mm from each corner of the PCB
  //    [5, 5]

  // Create standoffs for the PCB
  [
    30.48 - 24.765, // posx (front-back dist) [Y on PCB]
    55.88 - 50.8, // posy (side-to-side dist) [X on PCB]
    yappBaseOnly,
    yappHole
  ]
];


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//  
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = pcbStandHeight
//    p(3) = screwDiameter
//    p(4) = screwHeadDiameter (don't forget to add extra for the fillet)
//    p(5) = insertDiameter
//    p(6) = outsideDiameter
//   Optional:
//    p(7) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    p(8) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
connectors   =
[
  // Create standoffs for the PCB (not used)
  // [
  //   30.48 - 24.765, // posx (front-back dist) [Y on PCB]
  //   55.88 - 50.8, // posy (side-to-side dist) [X on PCB]
  //   standoffHeight,
  //   2.7, // screwDiameter
  //   6 + 1.25, // screwHeadDiameter (random guess)
  //   4.0, // insertDiameter
  //   8, // outsideDiameter
  // ]
];


//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase (Bottom), cutoutsLid (Top), cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//                        Required                Not Used        Note
//----------------------+-----------------------+---------------+------------------------------------
//  yappRectangle       | width, length         | radius        |
//  yappCircle          | radius                | width, length |
//  yappRoundedRect     | width, length, radius |               |     
//  yappCircleWithFlats | width, radius         | length        | length=distance between flats
//  yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be
//                      |                       |               | provided
//----------------------+-----------------------+---------------+------------------------------------
//
//  Parameters:
//   Required:
//    p(0) = from Back
//    p(1) = from Left
//    p(2) = width
//    p(3) = length
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                                  | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(a) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    n(b) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for 
//                             the cutout.
//    n(c) = { [yappMaskDef, hOffset, vOffset, rotation] } : If a list for a mask is added it 
//                            will be used as a mask for the cutout. With the Rotation and 
//                            offsets applied. This can be used to fine tune the mask 
//                            placement within the opening.
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { <yappOrigin>, yappCenter } // yappCenter means it positions the center of the cutout/circle
//    n(f) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsBase = 
[
  // polygon vents
  // [65,shellWidth/2 ,55,55, 5, yappPolygon ,0 ,30, yappCenter, shapeHexagon, maskHexCircles],

  // wires passthrough
  [
    0,
    pcbLength*0.65,
    25,
    25,
    25/2,
    yappCircle,
  ],

  // screw holes (back edge)
  [-5, 0, 0, 0, 3.2/2, yappCircle, yappCenter],
  [-5, pcbWidth, 0, 0, 3.2/2, yappCircle, yappCenter],
  [-5, pcbWidth/2, 0, 0, 3.2/2, yappCircle, yappCenter],

  // screw holes (right edge)
  [10, pcbWidth + 5, 0, 0, 3.2/2, yappCircle, yappCenter],
  [28, pcbWidth + 5, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength/2, pcbWidth + 5, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength*0.8, pcbWidth + 5, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength, pcbWidth + 5, 0, 0, 3.2/2, yappCircle, yappCenter],

  // screw holes (left edge)
  [pcbLength*0.2, 10, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength*0.5, 10, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength*0.8, 10, 0, 0, 3.2/2, yappCircle, yappCenter],

  // screw holes (middle)
  [pcbLength*0.3, pcbWidth/2, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength*0.5, pcbWidth/2, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength*0.8, pcbWidth/2, 0, 0, 3.2/2, yappCircle, yappCenter],

  // screw holes (front edge)
  [pcbLength+4, 0, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength+4, pcbWidth, 0, 0, 3.2/2, yappCircle, yappCenter],
  [pcbLength+4, pcbWidth/2, 0, 0, 3.2/2, yappCircle, yappCenter],

// , [0, 0, 10, 10, 0, yappRectangle,maskHexCircles]
// , [shellLength*2/3,shellWidth/2 ,0, 30, 20, yappCircleWithFlats, yappCenter]
// , [shellLength/2,shellWidth/2 ,10, 5, 20, yappCircleWithKey,yappCenter]
];

cutoutsLid  = 
[
  
];

cutoutsFront =  
[
];


cutoutsBack = 
[
  // USB programming hole
  [
    20.4 - 8,
    pcbThickness - 3,
    20 + 8*2, // width
    18, // height
    1, // radius
    yappRoundedRect
  ],

  // power supply cables
  [
    pcbWidth - 32,
    pcbThickness,
    20, // width
    6, // height
    2, // radius
    yappRoundedRect
  ]
];

cutoutsLeft =   
[
  [
    pcbLength/2,
    0,
    15, // width
    10, // height
    2, // radius
    yappRoundedRect
  ]
];

cutoutsRight =  
[
];



//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx | posy
//    p(1) = width
//    p(n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    n(a) = { <yappOrigin> | yappCenter }
//    n(b) = { yappSymmetric }
//    n(c) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [15, 10, yappFront, yappCenter,    yappRectangle, yappSymmetric]
   ,[25, 10, yappBack,  yappSymmetric, yappCenter]
   ,[30, 10, yappLeft,  yappRight,     yappCenter,    yappSymmetric]
];

//===================================================================
//  *** Base Mounts ***
//    Mounting tabs on the outside of the box
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = pos
//    p(1) = screwDiameter
//    p(2) = width
//    p(3) = height
//   Optional:
//    p(4) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
baseMounts =
[
//  [shellLength/2, 3, 10, 3, 2, yappLeft, yappRight]//, yappCenter]
];


//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = tubeLength
//    p(3) = tubeWidth
//    p(4) = tubeWall
//    p(5) = gapAbovePcb
//    p(6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    p(7) = lensThickness (how much to leave on the top of the lid for the light to shine 
//           through 0 for open hole : Default = 0/Open
//    p(8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    p(9) = filletRadius : Default = 0/Auto 
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(b) = { yappNoFillet }
//-------------------------------------------------------------------
lightTubes =
[
  // [(pcbLength/2)+10, 20,    // [0,1] Pos
  //   5, 5,                   // [2,3] Length, Width
  //   1,                      // [4]   wall thickness
  //   standoffHeight + pcbThickness + 4, // [5] Gap above base bottom
  //   yappRectangle,          // [6]   tubeType (Shape)
  //   0.5,                    // [7]   lensThickness
  //   yappCoordPCB            // [n1]
  // ]
  // ,
  // [(pcbLength/2)+10, 40,    // [0,1] Pos
  //   5, 10,                  // [2,3] Length, Width
  //   1,                      // [4]   wall thickness
  //   standoffHeight + pcbThickness + 4, // [5] Gap above base bottom
  //   yappCircle,             // [6]   tubeType (Shape)
  //   undef,                  // [7]
  //   undef,                  // [8]
  //   5,                      // [9]   filletRadius
  //   yappCoordPCB            // [n1]
  // ]
];

//===================================================================
//  *** Push Buttons ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = capLength for yappRectangle, capDiameter for yappCircle
//    p(3) = capWidth for yappRectangle, not used for yappCircle
//    p(4) = capAboveLid
//    p(5) = switchHeight
//    p(6) = switchTravel
//    p(7) = poleDiameter
//   Optional:
//    p(8) = Height to top of PCB : Default = standoffHeight + pcbThickness
//    p(9) = buttonType  {yappCircle|<yappRectangle>} : Default = yappRectangle
//    p(10) = filletRadius : Default = 0/Auto 
//-------------------------------------------------------------------
pushButtons = 
[
//-               0,   1,  2,  3, 4, 5,   6, 7
  //  [(pcbLength/2)+10, 65, 15, 10, 2, 3  , 1, 4]
  // ,[(pcbLength/2)+10, 85, 10, 10, 0, 2.0, 1, 4, standoffHeight, yappCircle]
];
             
//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   p(0) = posx
//   p(1) = posy/z
//   p(2) = rotation degrees CCW
//   p(3) = depth : positive values go into case (Remove) negative valies are raised (Add)
//   p(4) = plane {yappLeft | yappRight | yappFront | yappBack | yappLid | yappBaseyappLid}
//   p(5) = font
//   p(6) = size
//   p(7) = "label text"
//-------------------------------------------------------------------
labelsPlane =
[
    [20, 10, 0, 1, yappLid, "Liberation Mono:style=bold", 5, "GNCTR 2024 Claw Machine" ],
    [50, 20, 0, 1, yappLid, "Liberation Mono:style=bold", 5, "\"Bogg Story\"" ]
];


//===================================================================
//  *** Ridge Extension ***
//    Extension from the lid into the case for adding split opening at various heights
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = pos
//    p(1) = width
//    p(2) = height : Where to relocate the seam : yappCoordPCB = Above (positive) the PCB
//                                                yappCoordBox = Above (positive) the bottom of the shell (outside)
//   Optional:
//    n(a) = { <yappOrigin>, yappCenter } 
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//
// Note: Snaps should not be placed on ridge extensions as they remove the ridge to place them.
//-------------------------------------------------------------------
ridgeExtLeft =
[
];

ridgeExtRight =
[
];

ridgeExtFront =
[
];

ridgeExtBack =
[
];


//========= HOOK functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
// Pre = Attach the object Pre before doing Cutouts/Stands/Connectors. 


//===========================================================
// origin = box(0,0,0)
module hookLidInside()
{
  //if (printMessages) echo("hookLidInside() ..");
  
} // hookLidInside()
  

//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutside()
{
  //if (printMessages) echo("hookLidOutside() ..");
  
} // hookLidOutside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseInside()
{
  //if (printMessages) echo("hookBaseInside() ..");

  // add some mounts for zip ties (along Back edge)
  for (y = [-20, 0, 20, 40])
  translate([0, y+pcbLength*0.65, 10]) drawCableHolder_Z_X();

  // add some mounts for zip ties (along Left edge)
  for (x = [50, 70, 110, 130])
  translate([x-10, 0, 10]) rotate([90,0,90]) drawCableHolder_Z_X();

  // add some mounts for zip ties (along the bottom)
  for (y = [80, 100, 120, 140, 160])
  translate([60, y, 5]) rotate([0,90,90]) drawCableHolder_Z_X();
  
} // hookBaseInside()

module drawCableHolder_Z_X() {
  union() {
    // default orientation: cables run in Z, ziptie in Y
    difference() {
      translate([0, 0, 0]) cube([5, 8, 8]);

      // spot for ziptie
      translate([0, 0, 8/2-5/2]) cube([2, 100, 5]);

      // spot for cables
      translate([5-1.5, 8/2-5/2]) cube([1.5, 5, 100]);
    }
  }
}

//===========================================================
// origin = box(0,0,0)
module hookBaseOutside()
{
  //if (printMessages) echo("hookBaseOutside() ..");
  
} // hookBaseInside()

// **********************************************************
// **********************************************************
// **********************************************************
// *************** END OF TEMPLATE SECTION ******************
// **********************************************************
// **********************************************************
// **********************************************************

//---- This is where the magic happens ----
YAPPgenerate();

// Add the PCB for preview
if (enablePCBPreview) {
  % translate([
    wallThickness+paddingBack,
    wallThickness+paddingLeft,
    basePlaneThickness+standoffHeight
  ]) 
  translate([-24.765, -50.8]) rotate([0,0,90]) import("pcb_export.stl");
}

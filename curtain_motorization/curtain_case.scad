// This is a case to substitute one side of an IKEA blackout curtain holder.
// It's run by a small DC motor, and uses paperclips and staples on the curtain
// (or a conductive paint) for endstops.
//
//
// GPLv3, (C) Anders Breindahl <skrewz@skrewz.net> 20171031

/* TODO

Major TODO's:
- Ensure m3 holes connect
- Ensure pegs are tall enough
- Redesign: mount_plate should have sunk gears (and be wider?) and easy-access
  screwholes (and easy-placement (!) screwholes).
- Ensure *wall*mount cutouts look alike

Electronics:
- place electronics; void inside motormount, maybe?
- place paperclip mount holes

Mounting:
- gear_curtain rod mount (snug-fit hollow (conical?) cylinder)

Tuning / small stuff:
- add viewpoint to whole_thing render?
- add fuzz factors where appropriate
- integrate a (herringbone?) gear-building library
- get rid of mount_plate_depth and mount_plate_height (should be irrelevant)
- gear_curtain: notches for bearing grip (?)
*/

// Fuzz factors you may need to adjust:
// {{{

// Adjust gear_motor_axle_scaling if your gear_motor doesn't attach snugly to
// the motor (adjust the motor_* measurements if you use a different motor):
gear_motor_axle_scaling=1.17;

// Gear overlap. This is a messy affair---and it needn't be. Patches welcome,
// but for now: tune this until mechanical charm achieved.
gear_oversizing_for_teeth_meshing=1.07;

gear_motor_radius=5;
gear_curtain_radius=14;

// }}}


// FIXME in here:
// IKEA measurements: {{{
ikea_curtain_roll_diameter=35; // FIXME: measure
ikea_curtain_rod_outer_diameter=27; // FIXME: measure
ikea_curtain_rod_inner_diameter=25; // FIXME: measure
ikea_curtain_roll_cutout_diameter=45;
// }}}

// FIXME inhere:
// Motor sizes: {{{
motor_length=19;         // FIXME: what exactly?
motor_gearing_length=10; // FIXME: what, exactly?
motor_gearing_width=12;
motor_gearing_height=10;
motor_rear_clearance=2;
motor_diameter=12;
motor_flattened_height=10;
motor_axle_protrusion=9;
motor_axle_clearing=1; // length above gearbox
motor_axle_diameter=3;
motor_axle_flattened_diameter=2.5;


motor_total_length = motor_length + motor_gearing_length + motor_axle_protrusion;

// }}}

// Arbitrary assignments: {{{

motormount_case_width=140;
motormount_case_depth=30;
motormount_case_height=40;

// how far in from the edge should boltholes be placed?
motormount_bolthole_indent_off_ceiling=motormount_case_height-0;
motormount_bolthole_indent_off_wall=motormount_case_depth+2;
// how far between boltholes?
motormount_bolthole_interval=6;
// how deep into the motormount do we make the nut holes?
motormount_nuthole_inset=3;

// a paperclip should be able to slide up and down here
paperclip_cutout_width=1.5;
paperclip_cutout_depth=5;
paperclip_cutout_channel_length=10;

main_cable_exit_diameter=6;
main_cable_exit_clearance=1.5;

// }}}

// wall mount: {{{

wallmount_inclusion="false";
// distance between wood screw holes
// (such holes presumably already exist when this is installed)
wallmount_hole_interval=18;
// the distance from the top of the motormount/mountplate to the first hole:
// (such holes presumably already exist when this is installed)
wallmount_hole_downwards_indent=16; // TODO: this _should_ be a standard measurement for IKEA products.
wallmount_hole_radius=1.2; // TODO: this _should_ be a standard measurement for IKEA products.
wallmount_min_spacer=2; // The minimum width for a screwhead to rest on
// wallmount_screwdriver_hole_radius derived further down)

// }}}

// ceiling mount: {{{
ceilmount_inclusion="true";
// distance between wood screw holes
// (such holes presumably already exist when this is installed)
ceilmount_hole_interval=18;
// the distance from the top of the motormount/mountplate to the first hole:
// (such holes presumably already exist when this is installed)
ceilmount_hole_inwards_indent=12; // TODO: this _should_ be a standard measurement for IKEA products.
ceilmount_hole_radius=wallmount_hole_radius; // TODO: this _should_ be a standard measurement for IKEA products.
// ceilount_screwdriver_hole_radius derived further down)
// }}}

m3_radius=1.6;
m3_cap_radius=2.6;
m3_cap_clear_height=1.7;
// the width of a nut, if we're making cutouts for it:
m3_nut_width=6;

screwhead_min_sideways_clearance=10;
screwhead_min_clearance_at_head=4;
screwhead_min_clearance_for_insertion=20;
// TODO: use this instead of magic numbers to ensure enough holding layers' worth are made
screwhead_min_holding_depth=2;

mount_plate_depth=60;
mount_plate_height=60;
mount_plate_thickness=7;

gear_height=5;

bearing_height=5; // actual
bearing_cutout_height=7;
bearing_outer_radius=8; // actual
bearing_inner_radius=4; // actual
bearing_cutout_inner_radius=0.95*bearing_inner_radius;
bearing_cutout_outer_radius=1.04*bearing_outer_radius;

// (gear_connecting_radius is derived below)

// }}}

// Derivations: {{{

// This is where the motor gear sits in 3D space:
motor_gear_pos = [
  motormount_case_width,
  motormount_case_depth-motor_gearing_height/2,
  motormount_case_height-motor_gearing_width/2
];

// This is where the curtain gear sits in 3D space:
curtain_gear_pos = [
  motormount_case_width,
  0,
  0
];


// calculate intermediary variables for gear placements
// {{{
_angle_motor_curtain = (
  atan(
    (motor_gear_pos[2]-curtain_gear_pos[2])
    /
    (motor_gear_pos[1]-curtain_gear_pos[1])
    )
);

_inter_radii_motor_curtain = sqrt(
    pow(motor_gear_pos[1]-curtain_gear_pos[1],2)
    +
    pow(motor_gear_pos[2]-curtain_gear_pos[2],2)
);

// }}}

// Place/size the connecting gear in the middle between the curtain and motor gears:
// {{{

gear_connecting_radius = (_inter_radii_motor_curtain - gear_motor_radius - gear_curtain_radius)/2;


_connecting_gear_curtain_offset = gear_curtain_radius + gear_connecting_radius;

connecting_gear_pos = [
  curtain_gear_pos[0],
  curtain_gear_pos[1]+(_connecting_gear_curtain_offset*cos(_angle_motor_curtain)),
  curtain_gear_pos[2]+(_connecting_gear_curtain_offset*sin(_angle_motor_curtain))
];
// }}}


// The position of motormount-to-mountplate boltholes:
// {{{
// the width of the non-cut-out piece of motormount, z- and y-wise.
_bolthole_off_z = (motormount_case_height-ikea_curtain_roll_cutout_diameter/2)/2;
_bolthole_off_y = (motormount_case_depth-ikea_curtain_roll_cutout_diameter/2)/2;

// boltholes for M3 mounting to motormount
mounting_boltholes_upper = [
  /*
  [
    0,
    motormount_case_depth-motormount_bolthole_indent_off_wall+0*motormount_bolthole_interval,
    motormount_case_height-_bolthole_off_z
  ],
  */
  [
    0,
    motormount_case_depth-motormount_bolthole_indent_off_wall+1*motormount_bolthole_interval,
    motormount_case_height-_bolthole_off_z
  ],
];

mounting_boltholes_lower = [
  /*
  [
    0,
    motormount_case_depth-_bolthole_off_y,
    motormount_case_height-motormount_bolthole_indent_off_ceiling+0*motormount_bolthole_interval,
  ],
  */
  [
    0,
    motormount_case_depth-_bolthole_off_y,
    motormount_case_height-motormount_bolthole_indent_off_ceiling+1*motormount_bolthole_interval,
  ],
];

// FIXME: there's got to be a better way to do array concatenation, but I'm on a plane so can't RTFM.
mounting_boltholes = [ for (arr = [mounting_boltholes_upper, mounting_boltholes_lower ]) for (elm = arr) elm ];
// }}}

wallmount_screwdriver_hole_radius = 0.7*mount_plate_thickness/2;
ceilmount_screwdriver_hole_radius = 0.7*mount_plate_thickness/2;

// }}}

// modules to make gears:

//of off https://www.thingiverse.com/thing:3575
use <parametric_involute_gear_v5.0.scad>

// {{{
// un-Unused, using library instead:
// taken off /usr/share/openscad/examples/Functions/list_comprehensions.scad:
module star(num, radii) {
  function r(a) = (floor(a / 10) % 2) ? 10 : 8;
  polygon([for (i=[0:num-1], a=i*360/num, r=radii[i%len(radii)]) [ r*cos(a), r*sin(a) ]]);
}
module _old_gear_redirect(base_radius) {
  linear_extrude(height=gear_height)
    star(base_radius*PI*2, [
        base_radius+0.8,
        base_radius-1.2]);
}
//*/



module gear_redirect(base_radius) {
  /*
  bevel_gear (
      number_of_teeth=base_radius*PI*2,
      pressure_angle=30,
      outside_circular_pitch=1000);
      */

  resize([
      base_radius*2*gear_oversizing_for_teeth_meshing,
      base_radius*2*gear_oversizing_for_teeth_meshing,
      gear_height])
  translate([0,0,gear_height/2])
  {
    teeth=floor(base_radius*2);
    twist=100;
    gear (
        number_of_teeth=teeth,
        circular_pitch=100,
        pressure_angle=30,
        clearance = 0.2,
        gear_thickness = gear_height/2,
        rim_thickness = gear_height/2,
        rim_width = 5,
        hub_thickness = gear_height/2,
        hub_diameter=15,
        bore_diameter=0,
        circles=0,
        twist=twist/teeth);
    mirror([0,0,1])
    gear (
        number_of_teeth=teeth,
        circular_pitch=100,
        pressure_angle=30,
        clearance = 0.2,
        gear_thickness = gear_height/2,
        rim_thickness = gear_height/2,
        rim_width = 5,
        hub_thickness = gear_height/2,
        hub_diameter=15,
        bore_diameter=0,
        circles=0,
        twist=twist/teeth);
  }
}
// }}}

// This motor is available from Amazon:
// FIXME: linksy
module motor_axle ()
{ // {{{
  intersection(){
    cylinder(r=motor_axle_diameter/2,h=motor_axle_protrusion,$fn=20);

    translate ([-motor_axle_diameter/2,-motor_axle_diameter/2,(/*ccf*/-0.01)*motor_axle_protrusion])
      cube(size=[motor_axle_diameter,motor_axle_flattened_diameter,motor_axle_protrusion*1.02]);
  }
} // }}}
module motor ()
{ // {{{
  // The motor itself:
  union () {
    color("grey")
      intersection(){
        cylinder(r=motor_diameter/2,h=motor_length);
        translate ([-motor_gearing_width/2,-motor_gearing_height/2,0])
          cube(size=[motor_gearing_width,motor_gearing_height,motor_length]);
      }
    // The gearing mechanism:
    color("gold")
      translate([0,0,(/*ccf*/0.99)*motor_length])
      translate ([-motor_gearing_width/2,-motor_gearing_height/2,0])
      cube(size=[motor_gearing_width,motor_gearing_height,motor_gearing_length]);
    // The axle:
    color("silver")
      translate([0,0,(/*ccf*/0.98)*(motor_length+motor_gearing_length)])
      motor_axle();
  }
} // }}}

// Major parts below:

module mount_plate ()
{ // {{{
  // Calculate peg positions on mount_plate {{{
  peg_positions = [
    // The peg for the gear_curtain ball bearing:
    [0,0,0],
    // The peg for the gear_connecting ball bearing:
    [0,
    cos(_angle_motor_curtain)*_connecting_gear_curtain_offset,
    sin(_angle_motor_curtain)*_connecting_gear_curtain_offset
    ]
  ];
  // }}}

  union()
  {
    // Pegs (attached after gear countersink diff'ed off) :
    // {{{
    for (i = peg_positions)
      translate (i)
        rotate([0,90,0])
        cylinder(r=bearing_cutout_inner_radius,h=max(bearing_height,mount_plate_thickness),$fn=20);
    // }}}

    // mount plate with cutouts:
    difference ()
    {
      union()
      {
        // The plate itself (hull for prettiness)
        // {{{
        //translate([0,mount_plate_depth/2,mount_plate_height/2])
        hull()
        {
          rotate([90,0,90])
            cylinder(h=mount_plate_thickness,r=1.3*gear_curtain_radius,$fa=3);

          //cube([mount_plate_thickness,motormount_case_depth,motormount_case_height]);
          translate([0,-0.5*gear_curtain_radius,0])
            cube([mount_plate_thickness,motormount_case_depth+0.5*gear_curtain_radius,motormount_case_height]);
        }
        // }}}

      }
      // mountplate negative parts:
      union ()
      {
        // cutaways for gears:
        // {{{
        translate([-0.01,0,0])
          hull()
        {
          rotate([90,0,90])
            cylinder(h=gear_height,r=1.2*gear_curtain_radius,$fa=3);

          translate(peg_positions[1])
            rotate([90,0,90])
            cylinder(h=gear_height,r=1.2*gear_connecting_radius,$fa=3);

          translate([
                0,
                motormount_case_depth-motor_gearing_height/2,
                motormount_case_height-motor_gearing_width/2
            ])
            rotate([90,0,90])
              cylinder(h=gear_height,r=/*engorge; tends to be tight */1.25*gear_motor_radius,$fn=50);

        }
        // }}}

        // boltholes for mounting to motormount:
        // {{{
        for (s = mounting_boltholes)
          translate(s)
            translate([-mount_plate_thickness,0,0])
            rotate([0,90,0])
            {
              cylinder(r=m3_radius,h=3*mount_plate_thickness,$fn=20);
              translate([0,0,2*mount_plate_thickness-m3_cap_clear_height])
                cylinder(r=m3_cap_radius,h=2*m3_cap_clear_height,$fn=20);
            }
        // }}}

        // clearance for motor axle:
        // {{{
        translate([-mount_plate_thickness,0,0])
          translate([
              0,
              motormount_case_depth-motor_gearing_height/2,
              motormount_case_height-motor_gearing_width/2
          ])
            rotate([0,90,0])
            {
              cylinder(r=1.1*gear_motor_axle_scaling*motor_axle_diameter/2,h=3*mount_plate_thickness,$fn=20);
            }
        // }}}

        // screwholes for mounting to wall/window frame:
        if ("true" == wallmount_inclusion)
        {
          echo("wallmount_inclusion isn't well tested.");
          // {{{
          screwhole_positions = [
            [
              mount_plate_thickness/2,
              0,
              motormount_case_height-wallmount_hole_downwards_indent
            ],
            [
              mount_plate_thickness/2,
              0,
              motormount_case_height-wallmount_hole_downwards_indent-1*wallmount_hole_interval
            ],
          ];
          for (p = screwhole_positions)
            translate(p)
                {
                  translate([0,motormount_case_depth-_bolthole_off_y,0])
                    rotate([90,0,0])
                    cylinder(r=wallmount_screwdriver_hole_radius,h=mount_plate_depth,$fn=20);
                  translate([0,2*motormount_case_depth,0])
                    rotate([90,0,0])
                    cylinder(r=wallmount_hole_radius,h=mount_plate_depth,$fn=20);
                }
          // }}}
        }
        // screwholes for mounting to ceiling/window frame:
        if ("true" == ceilmount_inclusion)
        {
          // {{{
          screwhole_positions = [
            [
              0,
              motormount_case_depth-ceilmount_hole_inwards_indent-0*ceilmount_hole_interval,
              0
            ],
            [
              0,
              motormount_case_depth-ceilmount_hole_inwards_indent-1*ceilmount_hole_interval,
              0
            ],
          ];
            for (p = screwhole_positions)
              translate(p)
                {
                  translate([mount_plate_thickness/2,0,-motormount_case_height-wallmount_min_spacer])
                    rotate([0,0,90])
                    {
                      // FIXME: crude offset calculation
                      // screwdriver access hole:
                      translate([
                          0,
                          1*ceilmount_screwdriver_hole_radius,
                          motormount_case_height
                          +2*screwhead_min_clearance_for_insertion])
                        rotate([200,0,0])
                        cylinder(
                            r1=2*ceilmount_screwdriver_hole_radius,
                            r2=3*ceilmount_screwdriver_hole_radius,
                            h=screwhead_min_clearance_for_insertion-screwhead_min_clearance_at_head,
                            $fn=20);


                      // screw rotate-in port:
                      translate([
                          -0.5*2*ceilmount_screwdriver_hole_radius,
                          -0.5*ceilmount_screwdriver_hole_radius,
                          2*motormount_case_height])
                        mirror([0,0,1])// <- "grow" this in height away from the screw head rest
                        cube([2*ceilmount_screwdriver_hole_radius, mount_plate_thickness,screwhead_min_clearance_for_insertion]);

                      // screwhead clearance hole (mostly to punch through the
                      // mountplate() on either side):
                      // fixme: overlap with top-of-mountplate().
                      translate([-0.5*screwhead_min_sideways_clearance,-0.5*screwhead_min_sideways_clearance,2*motormount_case_height])
                        mirror([0,0,1])// <- "grow" this in height away from the screw head rest
                        cube([screwhead_min_sideways_clearance, screwhead_min_sideways_clearance,screwhead_min_clearance_at_head]);
                    }

                  translate([mount_plate_thickness/2,0,motormount_case_height/2])
                    rotate([0,0,90])
                    cylinder(r=ceilmount_hole_radius,h=2*motormount_case_height,$fn=20);
                }
          // }}}
        }
      }
    }
  }
} // }}}

module gear_motor ()
{ // {{{
  color("red")
  {
    difference() {
      // the gear shape:
      union ()
      {
        gear_redirect(gear_motor_radius);
      }
      union ()
      {
        translate([0,0,gear_motor_axle_scaling*motor_total_length-1])
          mirror([0,0,1]) scale(gear_motor_axle_scaling) motor();
      }
    }
  }
} // }}}

module gear_connecting ()
{ // {{{
  color("green")
  {
    mirror([0,1,0])
    {
      difference() {
        union ()
        {
          gear_redirect(gear_connecting_radius);
        }
        translate([0,0,-0.01]) cylinder(r=bearing_cutout_outer_radius,h=bearing_cutout_height+0.02,$fn=50);
      }
    }
  }
} // }}}

module gear_curtain ()
{ // {{{
  grappling_length=30;
  // how much the diameter should be smaller at the base of the prongs:
  grappling_shrinkage_percent=5;
  // TODO: inner diameter cutout should also have shrinkage
  color("red")
  {
    difference() {
      union()
      {
        translate([0,0,-1])
          cylinder(r=ikea_curtain_rod_inner_diameter/2-2,h=2);
        gear_redirect(gear_curtain_radius);
        translate([0,0,-grappling_length+gear_height])
        {
          difference()
          {
            cylinder(
              r1=ikea_curtain_rod_inner_diameter/2,
              r2=(100-grappling_shrinkage_percent)/100*ikea_curtain_rod_inner_diameter/2,
              h=grappling_length);
            // TODO: big logs cutting out may be easier to print
            for (rot = [0,90])
              translate([0,0,-gear_height-1])
              rotate([0,0,rot])
              cube([ikea_curtain_rod_inner_diameter*2,ikea_curtain_rod_inner_diameter/2.5,60],center=true);
          }
        }
      }
      translate([0,0,0.01*bearing_cutout_height])
        mirror([0,0,1]) // grow in appropriate direction with bearing_cutout_height
        translate([0,0,-gear_height])
        cylinder(r=bearing_cutout_outer_radius,h=bearing_cutout_height,$fn=50);
    }
  }
} // }}}

module motormount()
{ // {{{
  motor_scaling=1.05;
  wall_shrinkage_factor=0.90;
  electronics_box_wall_thickness=2;
  difference () {
    // The positive basic shape of the motormount, excl. cutouts:
    // {{{
    union()
    {
      difference() {
        cube([
          motormount_case_width,
          motormount_case_depth,
          motormount_case_height]);
        translate([0,0,0])
        {
        rotate([0,90,0])
          translate([0,0,-motormount_case_width])
            cylinder(r=ikea_curtain_roll_cutout_diameter/2,h=motormount_case_width*3, $fa=1);
        }
      }
    }
    // }}}

    // The negative motormount() parts:
    // {{{
    union ()
    {
      // a motor-sized gap (scaled up slightly) and cable throughway
      // {{{
      translate([
        motormount_case_width-motor_total_length+motor_axle_protrusion-motor_axle_clearing,
        motormount_case_depth-0.99*(motor_gearing_height/2)*motor_scaling,
        motormount_case_height-0.99*(motor_gearing_width/2)*motor_scaling])
          {
            rotate([0,90,0])
              scale(motor_scaling)
              motor();

            // the cable throughway
            translate([0.01*motor_length,0,])
            rotate([0,90,0])
              mirror([0,0,1])
              cylinder( r=motor_diameter/2*/*tunnel, after all:*/0.75, h=/*arbitrary:*/motor_length);

          }
      // }}}

      // electronics box
      // {{{
      translate([
          //(1-wall_shrinkage_factor)*(motormount_case_width-(motor_length+motor_gearing_length)),
          electronics_box_wall_thickness,
          //(1-wall_shrinkage_factor)/2*motormount_case_depth,
          electronics_box_wall_thickness,
          0+electronics_box_wall_thickness])
          //ikea_curtain_roll_cutout_diameter/2
          //+electronics_box_wall_thickness])
      {
        difference()
        {
          // fairly arbitrary:
          //electronics_box_length = wall_shrinkage_factor*motormount_case_width
          electronics_box_length = motormount_case_width-6*electronics_box_wall_thickness
              -(motor_length)/motor_scaling;
          //electronics_box_width = wall_shrinkage_factor*motormount_case_depth;
          electronics_box_width = motormount_case_depth-2*electronics_box_wall_thickness;
          union ()
          {
            translate([0,
                0,
                ikea_curtain_roll_cutout_diameter/2
                +electronics_box_wall_thickness])
            cube( [
                electronics_box_length,
                electronics_box_width,
                motormount_case_height-ikea_curtain_roll_cutout_diameter/2,
            ]);
            translate([0,0,0])
            {
              difference() {
                cube( [
                    electronics_box_length-sqrt(pow(motormount_case_depth,2))/2,
                    electronics_box_width,
                    motormount_case_height,
                ]);
                rotate([0,90,0])
                  translate([0,0,-motormount_case_width])
                    cylinder(r=ikea_curtain_roll_cutout_diameter/2,h=motormount_case_width*3, $fa=1);
              }
            }
          }
          translate([0,
              0,
              ikea_curtain_roll_cutout_diameter/2
              +electronics_box_wall_thickness])
          translate([electronics_box_length,-motormount_case_depth/2,0])
          for (offset = [0, electronics_box_width])
            translate([0,offset,0])
              rotate([0,0,45])
              cube( [
                  sqrt(pow(motormount_case_depth,2)*2)/2,
                  sqrt(pow(motormount_case_depth,2)*2)/2,
                  motormount_case_height-ikea_curtain_roll_cutout_diameter/2,
              ]);
        }
      }
      // }}}

      // boltholes for mounting to motormount:
      // {{{

      // the through-going holes themselves:
      translate ([motormount_case_width-motormount_nuthole_inset,0,0])
      {
        for (s = mounting_boltholes)
          translate(s)
            translate([-2*motormount_nuthole_inset,0,0])
              rotate([0,90,0])
                cylinder(r=m3_radius,h=4*motormount_nuthole_inset,$fn=20);

        // upper cutouts:
        for (s = mounting_boltholes_upper)
          translate(s)
            translate([-motormount_nuthole_inset,-m3_nut_width/2,-m3_nut_width/2])
              cube([motormount_nuthole_inset,m3_nut_width,3*m3_nut_width]);

        // lower cutouts:
        for (s = mounting_boltholes_lower)
          translate(s)
            translate([-motormount_nuthole_inset,-m3_nut_width/2,-m3_nut_width/2])
              cube([motormount_nuthole_inset,3*m3_nut_width,m3_nut_width]);
      }
      // }}}

      // paperclip endstop mount (and cable exit to electronics box)
      // {{{
      translate ([motormount_case_width-(motor_length+motor_gearing_length),0,0])
      {
        // the double slots onto the curtain
        // (paperclips are roughly 10mm wide, 5mm is conservative):
        for(x_offset = [5, 10])
          translate([x_offset,
              paperclip_cutout_depth,
              0])
            cube([paperclip_cutout_width,paperclip_cutout_depth,2*motormount_case_height]);

        // the box for wiring this up
        translate([
            0,
            paperclip_cutout_depth,
            ikea_curtain_roll_cutout_diameter/2+paperclip_cutout_channel_length])
          cube([motor_length,2*paperclip_cutout_depth,motormount_case_height]);

        // the wire exit into the electronics box
        translate([
            -motor_length,
            2*paperclip_cutout_depth,
            ikea_curtain_roll_cutout_diameter/2+paperclip_cutout_channel_length])
          //cube([1.5*motor_length,paperclip_cutout_depth,paperclip_cutout_depth]);
          translate([0,2*paperclip_cutout_depth/3,2*paperclip_cutout_depth/3])
          rotate([0,90,0])
          cylinder(h=1.5*motor_length,r=paperclip_cutout_depth/3,$fs=1);
      }
      // }}}

      // downwards main cable exit
      // {{{
      translate([
          motormount_case_width-3*motormount_nuthole_inset,
          motormount_case_depth-(main_cable_exit_diameter/2+main_cable_exit_clearance),
          0])
        rotate([0,-45,0])
        translate([0,0,-main_cable_exit_diameter])
        cylinder(r=main_cable_exit_diameter/2,h=motormount_case_width,$fn=20);
      // }}}

      // screwholes for mounting to wall/window frame:
      if ("true" == wallmount_inclusion)
      {
        // {{{
        screwhole_positions = [
          [
            1*motormount_case_width/7,
            0,
            motormount_case_height-wallmount_hole_downwards_indent
          ],
          [
            1*motormount_case_width/7,
            0,
            motormount_case_height-wallmount_hole_downwards_indent-1*wallmount_hole_interval
          ],
          [
            4*motormount_case_width/7,
            0,
            motormount_case_height-wallmount_hole_downwards_indent-1*wallmount_hole_interval
          ],
        ];
        for (p = screwhole_positions)
          translate(p)
              {
                translate([0,motormount_case_depth-_bolthole_off_y,0])
                  rotate([90,0,0])
                  cylinder(r=wallmount_screwdriver_hole_radius,h=mount_plate_depth,$fn=20);
                translate([0,2*motormount_case_depth,0])
                  rotate([90,0,0])
                  cylinder(r=wallmount_hole_radius,h=mount_plate_depth,$fn=20);
              }
        // }}}
      }
      // screwholes for mounting to ceiling/window frame:
      if ("true" == ceilmount_inclusion)
      {
        // {{{
        screwhole_positions = [
          // commented: doesn't make sense; tends to lie inside electronics cutout
          /*
          [
            0.1*motormount_case_width,
            0,
            0
          ],
          */
          [
            0.9*motormount_case_width,
            0,
            0
          ],
        ];
        for (p = screwhole_positions)
          translate(p)
              {
                translate([0,2*motormount_case_depth/5,-_bolthole_off_z])
                  rotate([0,0,90])
                  cylinder(r=ceilmount_screwdriver_hole_radius,h=motormount_case_height,$fn=20);
                translate([0,2*motormount_case_depth/5,motormount_case_height/2])
                  rotate([0,0,90])
                  cylinder(r=ceilmount_hole_radius,h=2*motormount_case_height,$fn=20);
              }
        // }}}
      }
    }
    // }}}
  }
} // }}}


//
// The following is the tests part. Various assertions about dimensions upheld,
// etc.

// {{{ Model sanity checks pre-build

color("magenta")
{

  // assert reasonable strength/thickness on mount_plate {{{ :
  if (mount_plate_thickness < gear_height+2)
  {
      %text(str("WARNING: mount_plate_thickness (",mount_plate_thickness,") must be at least 2 thicker than gear_height (",gear_height,")."),size=50);
  }
  // }}}
  // TODO: assert that screw holes don't overlap inside model {{{ :
  if (true)
  {
  }
  // }}}
  // assert that bearing isn't wider than mount_plate_thickness {{{ :
  if (mount_plate_thickness < bearing_height+2)
  {
      %text(str("WARNING: mount_plate_thickness (",mount_plate_thickness,") must be at least 2 larger than bearing_height (",bearing_height,")."),size=50);
  }
  // }}}
} // }}}

// {{{ Useful (?) output about model as-built

//echo (str("Screws of these sizes will be necessary:"));
//echo (str("- mount_plate has ",2*wallmount_hole_radius,"mm diameter ceiling mounting screwholes with a ",2*wallmount_screwdriver_hole_radius,"mm cap (and screwdriver) diameter"));

// }}}

// }}}

//
// The following is the rendering part.
//

// render_part does what it says on the tin: selects which part to lie down and
// render for printing/display.

// It's worth noting in this regard that most of the parts have been measured
// _as on_ the whole_thing render. Displaying them individually rotates working
// dimensions, and selective commenting in the whole_thing if() is preferable
// for development.

// It's a variable here, but will be
// overridden with a constant when invoked with -D. Cf. ./Makefile.
render_part="whole_thing";
//render_part="motormount";
//render_part="gear_motor";
//render_part="gear_connecting";
//render_part="gear_curtain";
//render_part="mount_plate";

//echo("have render_part:",render_part);

if (render_part == "whole_thing" ) {
  // {{{

  // The motormount:
  motormount();

  // The motor in its place:
  // {{{
  /*
  translate([
    motormount_case_width-motor_total_length+motor_axle_protrusion,
    motormount_case_depth-motor_gearing_height/2,
    motormount_case_height-motor_gearing_width/2,
    ])
  {
    color("blue")
      rotate([0,90,0])
      motor();
  }
  */

  // }}}

  // The mount plate
  // {{{
  translate([
      motormount_case_width,
      0,
      0 ])
    mount_plate();
  // }}}

  // The gear on the motor
  // {{{
  translate(motor_gear_pos)
  {
    translate([gear_height/10,0,0])
    color("red")
      rotate([0,90,0])
      gear_motor();
  }
  // }}}

  // The connecting gear
  // {{{
  translate(connecting_gear_pos)
  {
    translate([gear_height/10,0,0])
      rotate([0,90,0])
      gear_connecting();
  }
  // }}}

  // The gear on the curtain rod
  // {{{
  translate(curtain_gear_pos)
  {
    translate([gear_height/10,0,0])
    color("red")
      rotate([0,90,0])
      gear_curtain();
  }
  // }}}

  // A transparent curtain object end
  // {{{
  /*
  color(0,0,0,0)
    rotate([0,90,0])
    translate([0,0,-motormount_case_width])
      cylinder(r=ikea_curtain_roll_diameter/2,h=motormount_case_width*2, $fa=1);
      */
  // }}}

  // }}}
} else if (render_part == "motormount" ) {
  // {{{
  translate([motormount_case_height/2,-motormount_case_depth/2,0])
    rotate([0,-90,0])
    motormount();
  // }}}
} else if (render_part == "gear_motor" ) {
  // {{{
  gear_motor();
  // }}}
} else if (render_part == "gear_connecting" ) {
  // {{{
  gear_connecting();
  // }}}
} else if (render_part == "gear_curtain" ) {
  // {{{
  translate([0,0,gear_height])
    rotate([0,180,0])
    gear_curtain();
  // }}}
} else if (render_part == "mount_plate" ) {
  // {{{
  rotate([0,90,0])
    mount_plate();
  // }}}
}

// vim: ft=openscad fdm=marker fml=1 cindent

// This is a charger stand for a set of ``Backbeat Go'' headphones by Plantronics.
//
// (C) 20141007 Anders Breindahl <skrewz@skrewz.net>
// Licensed under the GPLv3+.

// Special variables for fragment rendering: {{{
//$fa
// is the angle of the fragments. It sets the minimum angle for a fragment. Even
// a huge circle does not have more fragments than 360 divided by this number.
// The default value is 12 (i.e. 30 fragments for a full circle).
//$fs
// is the size of the fragments and defines the minimum size of a fragment.
// Because of this variable very small circles have a smaller number of
// fragments then specified using $fa. The default value is 1.
//$fn
// is the number of fragments. It usually is 0. When this variable has a value
// greater than zero, the other two variables are ignored and full cirle is
// rendered using this number of fragments. The default value is 0.
// }}}

prod_run=true;

grid_size=50;

case_square_masurement=50;
cutout_depth=20;
cutout_width=15;
cutout_height=40;

cutout_side_inset = (case_square_masurement-2*cutout_width)/3;
cutout_bottom_inset = (case_square_masurement-cutout_height)/2;

plug_actual_width=12;
plug_actual_length=17;
plug_actual_height=7;

mounthole_radius = 8;

case_length=24+plug_actual_length+2*mounthole_radius;

module plug()
{ // {{{
  // microusb hardwired in, here.
  color("black") cube(size=[plug_actual_height,plug_actual_length,plug_actual_width]);
  color("silver") translate([plug_actual_height/2-0.5,plug_actual_length,plug_actual_width/2-3.5]) cube(size=[1,10,7]);

  color("black")
    intersection()
    {
      translate ([-plug_actual_height/2,-2*0.99*plug_actual_length,0]) cube(size=[2*plug_actual_height,2*plug_actual_length,plug_actual_width]);
      translate([plug_actual_height/2,0,14])
        rotate([0,270,0])
          rotate_extrude(convexity=10)
            translate([7,0,0])
              circle(r=1,$fn=8);
    }

} // }}}

module dock()
{ // {{{
  cutout_bottom_inset = -0.01;
  cylinder_shortened_by = 10;

  plughole_height = plug_actual_height * 1.05;
  plughole_width = plug_actual_width * 1.1;
  plughole_length = plug_actual_length * 1.1;


  // the placement of the plug
  if (!prod_run) {
    translate([cutout_side_inset+(cutout_width/2), cylinder_shortened_by, cutout_bottom_inset+0.6*cutout_height])
      translate([-plug_actual_height/2+(plughole_height-plug_actual_height)/2,mounthole_radius,(plughole_width-plug_actual_width)/2])
      plug();
  }

  difference() {
    cube (size=[case_square_masurement, case_length, case_square_masurement]);

    // these constitute the plug hole:
    translate([cutout_side_inset+(cutout_width/2), cylinder_shortened_by, cutout_bottom_inset+0.6*cutout_height]) rotate([0, 0, 0]) cylinder(r=mounthole_radius, h=case_length);
    translate([cutout_side_inset+(cutout_width/2), cylinder_shortened_by, cutout_bottom_inset+0.6*cutout_height]) translate([-plughole_height/2,0,0]) cube(size=[plughole_height,case_length,plughole_width]);
    translate([cutout_side_inset+(cutout_width/2), cylinder_shortened_by, cutout_bottom_inset+0.6*cutout_height]) translate([-plughole_height/2,0.5*plughole_width,0]) rotate([135, 0, 0]) translate([0, 0, -sqrt(2*plughole_width*plughole_width)]) cube(size=[plughole_height,plughole_length,plughole_width]);
    translate([cutout_side_inset+(cutout_width/2), cylinder_shortened_by, cutout_bottom_inset+0.6*cutout_height]) sphere(r=mounthole_radius,$fn=10);

    // these are the cutouts themselves:
    translate([cutout_side_inset, case_length-cutout_depth, cutout_bottom_inset])  cube (size=[cutout_width, 2*cutout_depth, cutout_height]);
    translate([case_square_masurement-cutout_side_inset-cutout_width, case_length-cutout_depth, cutout_bottom_inset])  cube (size=[cutout_width, 2*cutout_depth, cutout_height]);
    translate([cutout_side_inset/2+cutout_width, case_length-cutout_depth, cutout_bottom_inset])  cube (size=[2*cutout_side_inset, 2*cutout_depth, 0.5*cutout_height]);
  }

} // }}}

module cable_stowaway()
{ // {{{
  difference() {
    cube (size=[case_square_masurement, case_length, case_square_masurement]);
    translate([cutout_side_inset, 0.05*case_length, 0.1*case_square_masurement+0.001*case_square_masurement]) 
      cube (size=[case_square_masurement-2*cutout_side_inset, 2*case_length, case_square_masurement]);
  }
} // }}}



rotate([90,0,0])
{
  translate([0, 0, case_square_masurement])
  {
    dock();
  }
  cable_stowaway();
}


// vim: ft=openscad fdm=marker fml=1

// abreindahl@20180708: a hook for shower curtain attachment, to get lift off
// floor quite right, while being easy to pull.

piece_diameter=6;
desired_drop=115;
rod_side_radius=20;
curtain_side_radius=10;

// derived:
// (yes, trigonometry is involved, but this pretends a straight fall):
connector_rod_length=desired_drop-(2*rod_side_radius-piece_diameter/2)-(curtain_side_radius-piece_diameter/2);

translate([rod_side_radius-piece_diameter/2,0,piece_diameter/2])
{
  difference()
  {
    rotate_extrude($fn=50)
    {
      translate([rod_side_radius, 0, 0])
      {
        circle(r = piece_diameter/2, $fn=20);
      }
    }
    intersection()
    {
      rotate([0,0,-30])
        translate([0,0,-piece_diameter])
          cube([2*rod_side_radius,2*rod_side_radius,2*piece_diameter]);
      translate([0,0,-piece_diameter])
        cube([2*rod_side_radius,2*rod_side_radius,2*piece_diameter]);
      }
  }
  translate([rod_side_radius,0,0])
    sphere(r=piece_diameter/2);
  translate([rod_side_radius,0,0])
    rotate([0,90,0])
    cylinder(r = piece_diameter/2, h=connector_rod_length, $fn=20);
  
  translate([rod_side_radius+connector_rod_length,0,0])
    translate([0,-curtain_side_radius,0])
    difference()
    {
      rotate_extrude($fn=50)
        translate([curtain_side_radius, 0, 0])
        {
          circle(r = piece_diameter/2, $fn=20);
        }
      translate([-2*curtain_side_radius,0,-piece_diameter])
        cube([2*curtain_side_radius,2*curtain_side_radius,2*piece_diameter]);
    }
}


// vim: ft=openscad fdm=marker fml=1

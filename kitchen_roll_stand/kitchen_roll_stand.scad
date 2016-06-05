// A standing holder for kitchen rolls. Very basic.
// Tip: Attach bottom with poster sticker gum.
// (C) 2016 Anders Breindahl <skrewz@skrewz.net>. Released under the GPL3+.

$fn=50;
corner_radius=2.5;
foot_diameter=120;
foot_height=10;

column_height=220;
column_diameter=35;

union()
{
  cylinder(r=foot_diameter/2, h=foot_height);
  translate([0,0,foot_height*0.99])
    cylinder(r=column_diameter/2, h=column_height);
}


// vim: ft=openscad fdm=marker fml=1

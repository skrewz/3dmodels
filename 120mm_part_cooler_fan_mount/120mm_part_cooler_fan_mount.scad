// skrewz@20180225

difference()
{
  union()
  {
    translate([0,-30,0])
        difference()
        {
          cube([10,40,5]);
          translate([5,5,-0.01])
            cylinder(r=3,h=30);
          translate([5,25,-0.01])
            cylinder(r=3,h=30);
        }

    cube([10,10,30]);

    translate([0,0,30])
      rotate([-10,0,0])
      {
        difference()
        {
          cube([10,30,5]);
          translate([5,25,-0.01])
          cylinder(r=3,h=30);
        }
      }
  }
  union()
  {
  }
}


// vim: ft=openscad fdm=marker fml=1 cindent

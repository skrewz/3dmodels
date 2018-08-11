// skrewz@20170409:


// Notes to self: {{{
//$fa
// is the angle of the fragments. It sets the minimum angle for a fragment. Even
// a huge circle does not have more fragments than 360 divided by this number.
// The default value is 12 (i.e. 30 fragments for a full circle).
//$fs
// is the size of the fragments and defines the minimum size of a fragment.
// Because of this variable very small circles have a smaller number of
// fragments then specified using $fa. The default value is 1.
$fs = 1;
// is the number of fragments. It usually is 0. When this variable has a value
// greater than zero, the other two variables are ignored and full cirle is
// rendered using this number of fragments. The default value is 0.
// }}}


module attachment_plate()
{
  difference()
  {
    union() // positive parts:
    {
      translate([20,5,0])
        cylinder(r=5,h=10);

      translate([20,-5,-3])
      {
        rotate([-40,0,0])
          cylinder(r=6,h=20);
      }

      translate([0,-10,0])
        cube([40,20,2]);
    }
    union() // negative parts:
    {

      translate([20,-5,-3])
        rotate([-40,0,0])

      // hole for aluminium cylinder
      translate([0,0,-1])
        cylinder(r=2.2,h=40,$fs = 0.5);


      // holes for mounting
      translate([10,-3.5,-1])
        cylinder(r=1.5,h=3+2*1);
      translate([30,-3.5,-1])
        cylinder(r=1.5,h=3+2*1);

      // hole for cotton airseal
      //translate([20,-3.5,-0.01])
      //  cylinder(r1=3,r2=1,h=2);
    }
  }
}


difference()
{
  attachment_plate();

  translate([0,0,-10])
  cube([100,100,20],center=true);
}

// Production measurements:



// vim: ft=openscad fdm=marker fml=1 cindent

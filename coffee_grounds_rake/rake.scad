cube([100,2,20]);
rotate([0,0,30])
  cube([2,20,40]);
translate([0,-12,0])
{
  for (offset = [10,80])
  {
    translate([offset,0,0])
    {
      cube([10,2,20]);
      translate([0,0,20-2])
        cube([10,12,2]);
    }
  }
}

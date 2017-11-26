# Simple makefile for things relating to OpenSCAD, skeinforge etc.
#
# Look also into https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#Automatic_targets

.PHONY: all_parts clean

all_parts: curtain_case-part-whole_thing.stl \
  curtain_case-part-motormount.stl \
  curtain_case-part-gear_motor.stl \
  curtain_case-part-gear_connecting.stl \
  curtain_case-part-gear_curtain.stl \
  curtain_case-part-mount_plate.stl

%.stl: curtain_case.scad
	@# http://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment
	openscad $(shell  echo "$@" | sed -re "s/.*-part-([^-.]+).*/ -D'render_part=\"\1\"'/") -o $@ $<

clean:
	@rm -f *.stl

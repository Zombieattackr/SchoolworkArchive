## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Switches
set_property PACKAGE_PIN V17 [get_ports {input[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {input[0]}]
set_property PACKAGE_PIN V16 [get_ports {input[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {input[1]}]
set_property PACKAGE_PIN W16 [get_ports {input[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {input[2]}]
set_property PACKAGE_PIN W17 [get_ports {input[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {input[3]}]


# LEDs
set_property PACKAGE_PIN U16 [get_ports {leds[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
set_property PACKAGE_PIN E19 [get_ports {leds[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
set_property PACKAGE_PIN U19 [get_ports {leds[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
set_property PACKAGE_PIN V19 [get_ports {leds[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
	
#7 segment display
set_property PACKAGE_PIN W7 [get_ports {disp[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[0]}]
set_property PACKAGE_PIN W6 [get_ports {disp[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[1]}]
set_property PACKAGE_PIN U8 [get_ports {disp[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[2]}]
set_property PACKAGE_PIN V8 [get_ports {disp[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[3]}]
set_property PACKAGE_PIN U5 [get_ports {disp[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[4]}]
set_property PACKAGE_PIN V5 [get_ports {disp[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[5]}]
set_property PACKAGE_PIN U7 [get_ports {disp[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp[6]}]

set_property PACKAGE_PIN U2 [get_ports {anodes[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodes[0]}]
set_property PACKAGE_PIN U4 [get_ports {anodes[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodes[1]}]
set_property PACKAGE_PIN V4 [get_ports {anodes[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodes[2]}]
set_property PACKAGE_PIN W4 [get_ports {anodes[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodes[3]}]


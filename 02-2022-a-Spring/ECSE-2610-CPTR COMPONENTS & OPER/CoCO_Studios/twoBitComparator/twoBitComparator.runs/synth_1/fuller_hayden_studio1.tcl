# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Hayden/Desktop/ExportBack/CoCO_Studios/twoBitComparator/twoBitComparator.cache/wt [current_project]
set_property parent.project_path C:/Users/Hayden/Desktop/ExportBack/CoCO_Studios/twoBitComparator/twoBitComparator.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_vhdl -library xil_defaultlib C:/Users/Hayden/Desktop/ExportBack/CoCO_Studios/twoBitComparator/twoBitComparator.srcs/sources_1/new/fuller_hayden_studio1.vhd
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Hayden/Desktop/ExportBack/CoCO_Studios/twoBitComparator/twoBitComparator.srcs/constrs_1/new/twoBitCompatator.xdc
set_property used_in_implementation false [get_files C:/Users/Hayden/Desktop/ExportBack/CoCO_Studios/twoBitComparator/twoBitComparator.srcs/constrs_1/new/twoBitCompatator.xdc]


synth_design -top fuller_hayden_studio1 -part xc7a35tcpg236-1


write_checkpoint -force -noxdef fuller_hayden_studio1.dcp

catch { report_utilization -file fuller_hayden_studio1_utilization_synth.rpt -pb fuller_hayden_studio1_utilization_synth.pb }

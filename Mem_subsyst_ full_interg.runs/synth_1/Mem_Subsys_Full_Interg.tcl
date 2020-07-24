# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/.Xil/Vivado-7928-BERNY-LAP/incrSyn}
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.cache/wt} [current_project]
set_property parent.project_path {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_output_repo {d:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/Digital Design/Parameterizable_ALU/Parameterizable_ALU.srcs/sources_1/new/DigEng.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/new/Dual_Port_Mem.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/new/Mem_Manag_Unit.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/Digital Design/Parameterizable_ALU/parameterizable_register_bank/parameterizable_register_bank.srcs/sources_1/new/reg_bits.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/new/reg_bits.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/new/control_logic.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/Digital Design/Parameterizable_ALU/parameterizable_register_bank/parameterizable_register_bank.srcs/sources_1/new/reg_bank.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/new/reg_bank.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/Digital Design/Parameterizable_ALU/Parameterizable_ALU.srcs/sources_1/new/Parameterizable_ALU.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/new/Parameterizable_ALU.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/imports/Digital Design/Param_Datapath/Param_Datapath/Param_Datapath.srcs/sources_1/new/Param_Datapath.vhd}
  {D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/sources_1/new/Mem_Subsys_Full_Interg.vhd}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/constrs_1/new/CPU_Output_LEDS.xdc}}
set_property used_in_implementation false [get_files {{D:/MSc_DSE/AUTUMN_TERM/Digital Design/Lab/Group project/CPU_Final/Mem_subsyst_ full_interg.srcs/constrs_1/new/CPU_Output_LEDS.xdc}}]


synth_design -top Mem_Subsys_Full_Interg -part xc7z020clg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Mem_Subsys_Full_Interg.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Mem_Subsys_Full_Interg_utilization_synth.rpt -pb Mem_Subsys_Full_Interg_utilization_synth.pb"

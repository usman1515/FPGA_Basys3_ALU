#!/bin/tclsh

# Typical usage: vivado -mode tcl -source ../scripts/setup_prj_basys3.tcl

# set project name and directory
set prj_name "basys3_alu"
set prj_dir "./${prj_name}"

# Basys 3 board
set part "xc7a35tcpg236-1"
set board_part "digilentinc.com:basys3:part0:1.2"
set tb_lang "Verilog"
set rtl_lang "Verilog"
set default_lib "xil_defaultlib"

# for synthesis and implementation purposes
set top_module_rtl "alu"
# for testbench simulation purposes only
set top_module_tb "tb_alu"


# create a new project
create_project $prj_name $prj_dir -part $part

# set the project parameters 
set_property board_part $board_part [current_project]
set_property default_lib $default_lib [current_project]
set_property target_language $rtl_lang [current_project]
set_property simulator_language $tb_lang [current_project]

# add xilinx IP blocks

# add VHDL rtl source files to the project
add_files -force -fileset sources_1 {
    ./rtl/macros_alu.sv \
    ./rtl/alu.sv
}

# convert all VHDL files to VHDL 2008 standard
foreach file [get_files -filter {FILE_TYPE == VHDL}] {
    set_property file_type {VHDL 2008} $file
}

# set RTL top module - for design and implementation purposes
set_property top ${top_module_rtl} [current_fileset]
# set TB top module - for testbench simulation purposes
# set_property top ${top_module_tb} [current_fileset]

# add TB source files to the project
add_files -fileset sim_1 {
    ./tb/tb_alu.sv
}

# add constraint files to the project
add_files -fileset constrs_1 ./constraints/basys3.xdc

# update to set top and file compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
update_compile_order -fileset constrs_1 

# report compilation order
report_compile_order -fileset sources_1
report_compile_order -fileset sim_1 
report_compile_order -fileset constrs_1

# close the project
close_project


source scripts/color_func.tcl

# get start time
print_blue "Run started at:     [clock format [clock seconds] -format "%d-%b-%Y - %I:%M:%S - %p"]"
set current_datetime [clock format [clock seconds] -format "%Y-%m-%d_%H:%M:%S"]

# * pwd
set prj_dir             [pwd]
set prj_name            [file tail $prj_dir]

# * vars global - fpga and board part num - nexys a7 100t
set fpga_part_name      "xc7a35tcpg236-1"
set board_part_name     "digilentinc.com:basys3:part0:1.2"
set top_module_rtl      "alu"

# * vars rtl analysis
set name_run_rtl        "rtl_1"
set name_chkp_ip        "post_ip_synth"
set name_chkp_rtl       "post_rtl_analysis"

# * vars synthesis
set name_run_synth      "synth_1"
set name_chkp_synth     [lindex $argv 0]
set name_rpt_clk        "post_synth_clocks"
set name_rpt_timing     "post_synth_timing"
set name_rpt_util       [lindex $argv 4]

# * vars implementation
# opt_design
set name_run_impl1      "impl_1"
set name_chkp_impl1     [lindex $argv 1]
set name_rpt_clk1       "post_impl1_clocks"
set name_rpt_timing1    "post_impl1_timing"
set name_rpt_util1      [lindex $argv 5]
# power_opt_design
set name_run_impl2      "impl_2"
set name_chkp_impl2     "post_impl2_power_opt_design"
set name_rpt_clk2       "post_impl2_clocks"
set name_rpt_timing2    "post_impl2_timing"
set name_rpt_util2      "post_impl2_utilization"
# place_design
set name_run_impl3      "impl_3"
set name_chkp_impl3     [lindex $argv 2]
set name_rpt_clk3       "post_impl3_clocks"
set name_rpt_timing3    "post_impl3_timing"
set name_rpt_util3      [lindex $argv 6]
# phys_opt_design
set name_run_impl4      "impl_4"
set name_chkp_impl4     "post_impl4_phys_opt_design"
set name_rpt_clk4       "post_impl4_clocks"
set name_rpt_timing4    "post_impl4_timing"
set name_rpt_util4      "post_impl4_utilization"
# route_design
set name_run_impl5      "impl_5"
set name_chkp_impl5     [lindex $argv 3]
set name_rpt_clk5       "post_impl5_clocks"
set name_rpt_timing5    "post_impl5_timing"
set name_rpt_util5      [lindex $argv 7]

# * vars bitstream
set name_bitstream      "bitstream_${prj_name}"
set name_run_bit        "bit_1"
set name_rpt_clk6       "post_bit_clocks"
set name_rpt_timing6    "post_bit_timing"
set name_rpt_util6      "post_bit_utilization"

# * paths global
set dir_rtl_veri        "${prj_dir}/rtl"
set dir_ip_srcs         "${prj_dir}/ip"
set dir_constraint      "${prj_dir}/constraints"

set dir_bin             "bin"
set dir_rpt             "${dir_bin}/reports"
set dir_chkp            "${dir_bin}/checkpoints"
set dir_logs            "${dir_bin}/logs"

# * create in memory project
# set fpga
set_part ${fpga_part_name}
# set board
set_property board_part ${board_part_name} [current_project]

# * set max threads for implementation phases 1-8
set_param general.maxThreads 8


# create output dir
if {![file isdirectory $dir_rpt]} {
    file mkdir -p $dir_rpt
    print_blue "\nDirectory created: $dir_rpt"
} else {
    print_blue "\nDirectory already exists: $dir_rpt"
}
# create checkpoints dir
if {![file isdirectory $dir_chkp]} {
    file mkdir -p $dir_chkp
    print_blue "\nDirectory created: $dir_chkp"
} else {
    print_blue "\nDirectory already exists: $dir_chkp"
}
# create logs dir
if {![file isdirectory $dir_logs]} {
    file mkdir -p $dir_logs
    print_blue "\nDirectory created: $dir_logs"
} else {
    print_blue "\nDirectory already exists: $dir_logs"
}

# read all verilog files
print_yellow "reading Verilog files"
set veri_files [glob -directory $dir_rtl_veri -types f -join *.sv]
read_verilog -library xil_defaultlib -verbose $veri_files

# read constraint files
print_yellow "reading constraint file/s"
print_blue "reading constraint sources for Basys3"
read_xdc ${dir_constraint}/basys3.xdc

# * set top module RTL
print_yellow "setting top module RTL and updating compilation order"
set_property top ${top_module_rtl} [current_fileset]

# update and report compilation order of RTL files
print_yellow "update_compile_order sources_1"
update_compile_order -fileset sources_1
print_yellow "report_compile_order sources_1"
report_compile_order -fileset sources_1

# * print IP status for .xci files
print_yellow "print IP status for .xci files"
report_ip_status


# synthesis
print_yellow "running synthesis"
synth_design -name ${name_run_synth} -top ${top_module_rtl} -part ${fpga_part_name} -flatten_hierarchy rebuilt
print_yellow "writing checkpoint: ${name_chkp_synth}"
write_checkpoint -force ${dir_chkp}/${name_chkp_synth}.dcp
print_blue "writing report_utilization"
report_utilization -file ${dir_rpt}/${name_rpt_util}_util.rpt

# opt_design
print_yellow "running implementation phase: opt_design"
opt_design -directive Default -verbose -debug_log
print_yellow "writing checkpoint: ${name_chkp_impl1}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl1}.dcp

# power_opt_design
print_yellow "running implementation phase: power_opt_design"
power_opt_design -verbose
# * write checkpoint
print_yellow "writing checkpoint: ${name_chkp_impl2}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl2}.dcp

# place_design
print_yellow "running implementation phase: place_design"
place_design -directive Default -verbose -debug_log
print_yellow "writing checkpoint: ${name_chkp_impl3}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl3}.dcp

# phys_opt_design
print_yellow "running implementation phase: phys_opt_design"
phys_opt_design -directive Default -verbose
print_yellow "writing checkpoint: ${name_chkp_impl4}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl4}.dcp

# route_design
print_yellow "running implementation phase: route_design"
route_design -directive Default -tns_cleanup -verbose
print_yellow "writing checkpoint: ${name_chkp_impl5}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl5}.dcp
print_blue "writing report_utilization"
report_utilization -file ${dir_rpt}/${name_rpt_util5}_util.rpt

# bitstream
print_yellow "generating bitstream"
write_bitstream -force -verbose ${prj_dir}/${name_bitstream}.bit


# copy current log generated to logs folder
file copy -force [file join $prj_dir vivado.log] [file join $dir_logs "vivado_${current_datetime}.log"]
print_blue "Log file copied to: [file join $dir_logs "vivado_${current_datetime}.log"]"


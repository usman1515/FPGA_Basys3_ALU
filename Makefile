# ========== vars
prj_dir = $(realpath .)

# random run name
config = run1_basys3


# synthesis and implementation report name
post_synth = synth_$(config)
impl_1 = impl_1_opt_$(config)
impl_3 = impl_3_place_$(config)
impl_5 = impl_5_route_$(config)
post_synth_utilization = synth_util_$(config)
post_impl1_utilization = impl1_opt_util_$(config)
post_impl3_utilization = impl3_place_util_$(config)
post_impl5_utilization = impl5_route_design_$(config)

# paths
DIR_CHECKPOINT = ./bin/checkpoints/$(config)
DIR_REPORT = ./bin/reports/$(config)


# ========== targets

# default target
default: help

# create basys 3 project
setup_prj_basys3:
	@ vivado -mode tcl -source ./scripts/setup_prj_basys3.tcl

# run synthesis and implementation
run_vivado_basys3:
	@ rm -rf .gen .srcs
	@ vivado -mode batch -nojournal -notrace -stack 2000 \
		-source ./scripts/main_basys3.tcl -tclargs \
		$(post_synth) \
		$(impl_1) $(impl_3) $(impl_5) \
		$(post_synth_utilization) \
		$(post_impl1_utilization) $(post_impl3_utilization) $(post_impl5_utilization)

clean_checkpoints:
	@ rm -rf ./bin/checkpoints

clean_logs:
	@ rm -rf ./bin/logs
	@ rm -rf vivado_*.jou vivado_*.log *.log *.str *.jou

clean_reports:
	@ rm -rf ./bin/reports

clean_projects:
	@ rm -rf ./basys3_alu
	@ rm -rf .gen .srcs
	@ rm -rf ./-p .Xil

clean_all:
	@ make clean_checkpoints clean_logs clean_reports clean_projects

help:
	@ echo " "
	@ echo ---------------------------- Targets in Makefile ---------------------------
	@ echo ----------------------------------------------------------------------------
	@ echo " setup_prj_basys3:	setup the a vivado FPGA project using the Nexys A7 board"
	@ echo " run_vivado_basys3:	run the entire synthesis and implementation flow in batch mode for the Nexys A7 board."
	@ echo " "
	@ echo " move_checkpoints:	create a run config folder and move all checkpoints to it"
	@ echo " move_reports:		create a run config folder and move all reports to it"
	@ echo " "
	@ echo " clean_logs:		delete all logs"
	@ echo " clean_checkpoints:	delete all checkpoints"
	@ echo " clean_reports:		delete all reports"
	@ echo " clean_projects:	delete all vivado projects"
	@ echo " clean_all:			run all clean_* targets"
	@ echo ----------------------------------------------------------------------------


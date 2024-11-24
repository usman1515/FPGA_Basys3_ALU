# Basys 3 ALU

## Introduction
The repo is simply my first attempt of designing, testing, synthesizing and implementing a simple
4-bit 16 mode sequential Arithmetic and Logic Unit (ALU) on a
[Basys3](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) FPGA board.

The idea of the project was simply to learn how to setup a Vivado project, add RTL, TB and
constraint files. Then you can open and run the project in either normal mode and batch mode.

## Directory Structure

```bash
├── basys3_alu/
├── bin/
│   ├── checkpoints/
│   ├── logs/
│   └── reports/
├── constraints/
├── rtl/
├── scripts/
├── tb/
├── Makefile
└── README.md
```


<!-- vcd file
basys3_4bit_alu.sim/sim_1/behav/xsim/04_alu.vcd

tb compilation log
basys3_4bit_alu.sim/sim_1/behav/xsim/elaborate.log

tb simu output
basys3_4bit_alu.sim/sim_1/behav/xsim/simulate.log

bitstream
basys3_4bit_alu.runs/impl_1/top.bit -->

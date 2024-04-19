# Basys 3 ALU

## Introduction
The repo is simply my first attempt of designing, testing, synthesizing and implementing a simple 4-bit 16 mode sequential Arithmetic and Logic Unit (ALU) on a [Basys3](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) FPGA board.

## Directory Structure
```
.
├── .vscode
├── basys3_4bit_alu.cache
├── basys3_4bit_alu.hw
├── basys3_4bit_alu.ip_user_files
├── basys3_4bit_alu.runs
│   ├── impl_1
│   └── synth_1
├── basys3_4bit_alu.sim
│   └── sim_1
│       └── behav
│           └── xsim
├── basys3_4bit_alu.srcs
│   ├── constrs_1
│   ├── sim_1
│   ├── sources_1
│   └── utils_1
├── basys3_4bit_alu.xpr
└── README.txt
```

<!-- vcd file
basys3_4bit_alu.sim/sim_1/behav/xsim/04_alu.vcd

tb compilation log
basys3_4bit_alu.sim/sim_1/behav/xsim/elaborate.log

tb simu output
basys3_4bit_alu.sim/sim_1/behav/xsim/simulate.log

bitstream
basys3_4bit_alu.runs/impl_1/top.bit -->